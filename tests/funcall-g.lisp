(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(defun-g funcall-g-test-0 ((val :vec2))
  (v! val val))

;;------------------------------------------------------------

(def-test funcall-g-0 (:suite cepl.pipelines)
  (ensure-cepl
    (let ((v2 (v! 1 2)))
      (is (v4:= (v! v2 v2) (funcall-g-test-0 v2))))))
