(in-package :cepl.tests)


(defun-g doubler ((a :int))
  (* a 2))

(defun-g int-to-int-dispatcher ((fn (function (:int) :int)) (a :int))
  (funcall fn a))


(defun-g innocent ((a :int))
  (v! 1 2 3 (int-to-int-dispatcher #'(doubler :int) a)))
