(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(def-test fbo-0 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo 0)))
      (is (not (null fbo)))
      (is (not (null (attachment fbo 0))))
      (is (null (attachment fbo 1)))
      (is (null (attachment fbo :d))))))

(def-test fbo-1 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo 0 :d)))
      (is (not (null fbo)))
      (is (not (null (attachment fbo 0))))
      (is (null (attachment fbo 1)))
      (is (not (null (attachment fbo :d)))))))

(def-test fbo-2 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo 0 1)))
      (is (not (null fbo)))
      (is (not (null (attachment fbo 1))))
      (is (null (attachment fbo :d))))))

(def-test fbo-3 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo 0 1 :d)))
      (is (not (null fbo)))
      (is (not (null (attachment fbo 1))))
      (is (not (null (attachment fbo :d)))))))

(def-test fbo-4 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0 :dimensions (100 100)))))
      (is (not (null fbo))))))

(def-test fbo-5 (:suite cepl.fbos)
  (ensure-cepl
    (signals cepl.errors:attachments-with-different-sizes
      (make-fbo '(0 :dimensions (100 100))
                :d))))

(def-test fbo-6 (:suite cepl.fbos)
  (ensure-cepl
    (signals cepl.errors:attachments-with-different-sizes
      (make-fbo '(0 :dimensions (100 100))
                '(1 :dimensions (10 100))))))

(def-test fbo-7 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0 :dimensions (100 100))
                                '(:d :dimensions (100 100)))))
      (is (not (null fbo))))))

(def-test fbo-8 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0
                                  :dimensions (100 100)
                                  :element-type :rgba8))))
      (is (not (null fbo))))))

(def-test fbo-9 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0
                                  :dimensions (100 100)
                                  :element-type :vec4))))
      (is (not (null fbo))))))

(def-test fbo-10 (:suite cepl.fbos)
  (ensure-cepl
    (signals error
      (make-fbo '(0
                  :dimensions (100 100)
                  :element-type :vec4)
                '(:d
                  :dimensions (100 100)
                  :element-type :vec4)))))

(def-test fbo-11 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo :d)))
      (is (not (null fbo))))))

;;------------------------------------------------------------

(def-test render-to-fbo-0 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0 :dimensions (4 4))))
                 (pipeline (pipeline-g (:points)
                             :fragment (lambda-g ((uv :vec2))
                                         (v! 1 0 0 0))))
                 (bs (make-buffer-stream nil :primitive :points)))
      (with-fbo-bound (fbo)
        (map-g pipeline bs))
      (let* ((data (pull-g (attachment fbo 0)))
             (elem (caar data)))
        (is (every #'equal (v!uint8 255 0 0 0) elem))))))

(def-test render-to-fbo-1 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0 :dimensions (4 4) :element-type :vec4)))
                 (pipeline (pipeline-g (:points)
                             :fragment (lambda-g ((uv :vec2))
                                         (v! 0 0 1 0))))
                 (bs (make-buffer-stream nil :primitive :points)))
      (with-fbo-bound (fbo)
        (map-g pipeline bs))
      (let* ((data (pull-g (attachment fbo 0)))
             (elem (caar data)))
        (is (every #'equal (v! 0 0 1 0) elem))))))

;;------------------------------------------------------------
