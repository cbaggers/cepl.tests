(in-package :cepl.tests)

(defun-g doubler ((a :int))
  (* a 2))

(defun-g int-to-int-dispatcher ((fn (function (:int) :int))
                                (a :int))
  (funcall fn a))

(defun-g innocent ((a :int))
  (v! 1 2 3 (int-to-int-dispatcher #'(doubler :int) a)))

(defun-g min-vert ((vert :vec4))
  vert)

(defun-g min-frag ()
  (v! 1 0 0 0))

(defun-g func-frag (&uniform (wat (function (:int) :int)))
  (v! 1 0 0 (funcall wat 10)))


(def-g-> pline0 ()
  (min-vert :vec4)
  (min-frag))

(def-g-> pline1 ()
  (min-vert :vec4)
  (func-frag))

(defun bake-a-func ()
  (bake 'pline1 :wat '(doubler :int)))

(defun-g pass-through-vert ((vert g-pt))
  (values (:smooth (v! (pos vert) 1))
	  (tex vert)))

;;------------------------------------------------------------

(defun-g fooharhar ()
  (in *world-space*
    (in *clip-space*
      (sv! 0 0 0 0))))

(defun-g testaroo ((tc :vec2))
  (fooharhar)
  (v! 0 0 0 0))

(def-g-> testarooline ()
  (pass-through-vert g-pt)
  (testaroo :vec2))
