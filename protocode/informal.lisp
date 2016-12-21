(in-package :cepl.tests)


(defun-g doubler ((a :int))
  (* a 2))

(defun-g int-to-int-dispatcher ((fn (function (:int) :int)) (a :int))
  (funcall fn a))
