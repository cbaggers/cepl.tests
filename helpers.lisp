(in-package :cepl.tests)

;;------------------------------------------------------------
;; Helper macros

(defmacro ensure-cepl (&body body)
  `(let ((cepl.pipelines::*suppress-upload-message* t))
     (when (cepl.lifecycle:uninitialized-p)
       (cepl:repl))
     ,@body))

(defmacro with-free (name thing &body body)
  (let ((name (or name (gensym "thing"))))
    `(let ((,name ,thing))
       (unwind-protect (progn ,@body)
         (free ,name)))))

(defmacro with-free* (bindings &body body)
  `(let* ,bindings
     (unwind-protect (progn ,@body)
       ,@(loop :for (name) :in bindings :collect
            `(free ,name)))))

;;------------------------------------------------------------
