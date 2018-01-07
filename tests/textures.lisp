(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(def-test textures-0 (:suite cepl.textures)
  (ensure-cepl
    (let ((data (list (v!uint8 255 0 0)
                      (v!uint8 0 255 0)
                      (v!uint8 0 0 255))))
      (with-free* ((tex (make-texture data :element-type :rgb8)))
        (let* ((pulled (pull-g tex))
               (src (mapcar λ(coerce _ 'list) data))
               (dst (mapcar λ(coerce _ 'list) pulled)))
          (is (equal src dst)))))))

;; (def-test textures-1 (:suite cepl.textures)
;;   (let ((data '((255 0 0)
;;                 (0 255 0)
;;                 (0 0 255))))
;;     (with-free* ((tex (make-texture data :element-type :rgb8))
;;                  (pulled (pull-g tex))
;;                  (pulled-lists (mapcar λ(coerce _ 'list) pulled)))
;;       (is (equal data pulled-lists)))))
