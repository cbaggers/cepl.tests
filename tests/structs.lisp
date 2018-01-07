(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(defstruct-g test-struct-0
  (foo :uint)
  (bar (:uint 10)))

(defstruct-g (test-struct-1 :layout std-140)
  (foo :uint)
  (bar (:uint 10)))

;;------------------------------------------------------------

(def-test structs-0 (:suite cepl.types)
  (ensure-cepl
    (let ((data (loop :for i :below 3 :collect
                   (list i (loop :for x :below 10 :collect x)))))
      (with-free* ((arr (make-gpu-array data
                                        :dimensions 3
                                        :element-type 'test-struct-0)))
        (is (equal data (pull-g arr)))))))

(def-test structs-1 (:suite cepl.types)
  (ensure-cepl
    (handler-case
        (with-free* ((pipeline
                      (pipeline-g ()
                        :compute
                        (lambda-g (&uniform (woop test-struct-1))
                          (declare (local-size :x 1 :y 1 :z 1))
                          (values)))))
          (fail "should have failed as doesnt specify :ubo or :ssbo"))
      (cepl.errors:invalid-layout-for-uniform ()
        (pass)))))

(def-test structs-2 (:suite cepl.types)
  (ensure-cepl
    (with-free* ((pipeline-0
                  (pipeline-g ()
                    :compute
                    (lambda-g (&uniform (woop test-struct-1 :ssbo))
                      (declare (local-size :x 1 :y 1 :z 1))
                      (values))))
                 (pipeline-1
                  (pipeline-g ()
                    :compute
                    (lambda-g (&uniform (woop test-struct-1 :ubo))
                      (declare (local-size :x 1 :y 1 :z 1))
                      (values)))))
      (pass))))

(def-test structs-3 (:suite cepl.types)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0 :dimensions (4 4) :element-type :vec4)))
                 (bs (make-buffer-stream nil :primitive :points))
                 (val (make-g-pnt
                  :position (v! 1 1 1)
                  :normal (v! 2 2 2)
                  :texture (v! 3 3))))
      (with-free* ((pipeline (pipeline-g (:points)
                               :fragment (lambda-g ((uv :vec2)
                                                    &uniform
                                                    (jam g-pnt))
                                           (v! (pos jam) 0)))))
        (with-fbo-bound (fbo)
          (clear-fbo fbo)
          (map-g pipeline bs :jam val))
        (let* ((data (pull-g (attachment fbo 0))))
          (is (every #'equal (v! 1 1 1 0) (caar data)))))
      ;;
      (with-free* ((pipeline (pipeline-g (:points)
                               :fragment (lambda-g ((uv :vec2)
                                                    &uniform
                                                    (jam g-pnt))
                                           (v! (norm jam) 0)))))
        (with-fbo-bound (fbo)
          (clear-fbo fbo)
          (map-g pipeline bs :jam val))
        (let* ((data (pull-g (attachment fbo 0))))
          (is (every #'equal (v! 2 2 2 0) (caar data)))))
      ;;
      (with-free* ((pipeline (pipeline-g (:points)
                               :fragment (lambda-g ((uv :vec2)
                                                    &uniform
                                                    (jam g-pnt))
                                           (v! (tex jam) 0 0)))))
        (with-fbo-bound (fbo)
          (clear-fbo fbo)
          (map-g pipeline bs :jam val))
        (let* ((data (pull-g (attachment fbo 0))))
          (is (every #'equal (v! 3 3 0 0) (caar data))))))))

;;------------------------------------------------------------
