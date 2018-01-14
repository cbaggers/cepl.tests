(in-package :cepl.tests)

;; This is fun. What we do here is to implement a function that varjo.tests
;; calls on every successful compile it runs. We then use CEPL to test it.

(defun varjo.tests::glsl-compiles-p (elem)
  (ensure-cepl
    (run-test-pipeline elem)))

(defmethod run-test-pipeline (compiled)
  t)

(defmethod run-test-pipeline ((compiled compiled-vertex-stage))
  (try-compile compiled))

(defmethod run-test-pipeline ((compiled compiled-fragment-stage))
  (try-compile compiled))

(defun try-compile (elem)
  (let* ((prog-id (%gl:create-program))
         (shader (cepl.pipelines::%gl-make-shader-from-varjo elem)))
    (%gl:attach-shader prog-id shader)
    (%gl:link-program prog-id)
    (let ((fail-message
           (unless (gl:get-program prog-id :link-status)
             (format nil "Error Linking Program~%~a~%~%Compiled-stage:~%~a"
                     (gl:get-program-info-log prog-id)
                     (glsl-code elem)))))
      (gl:detach-shader prog-id shader)
      (gl:delete-program prog-id)
      (when fail-message
        (error fail-message))
      t)))
