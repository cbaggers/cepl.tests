(in-package :cepl.tests)

;; This is fun. What we do here is to implement a function that varjo.tests
;; calls on every successful compile it runs. We then use CEPL to test it.

(defun varjo.tests::glsl-compiles-p (elem)
  (ensure-cepl
    (try-compile elem)))

(defmethod run-test-pipeline (compiled)
  t)

(defun try-compile (stages)
  (let ((ver (cepl.context::get-best-glsl-version (cepl-context))))
    (when (find-if (lambda (x) (string>= ver x))
                   (context (first stages)))
      (let* ((prog-id (%gl:create-program))
             (shaders nil))
        (loop :for stage :in stages :do
           (let ((shader (cepl.pipelines::%gl-make-shader-from-varjo stage)))
             (%gl:attach-shader prog-id shader)
             (push shader shaders)))
        (%gl:link-program prog-id)
        (let ((fail-message
               (unless (gl:get-program prog-id :link-status)
                 (format nil "Error Linking Program~%~a~%~%Compiled-stages:~{~%~a~}"
                         (gl:get-program-info-log prog-id)
                         (mapcar #'glsl-code stages)))))
          (loop :for shader :in shaders :do
             (gl:detach-shader prog-id shader))
          (gl:delete-program prog-id)
          (when fail-message
            (error fail-message))
          t)))))
