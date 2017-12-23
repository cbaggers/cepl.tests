(in-package :cepl.tests)

;;
;; These are tests that we need to be true before we can rely
;; on the other tests
;;

;;------------------------------------------------------------

(5am:def-suite cepl.internals)
(5am:in-suite cepl.internals)

;;------------------------------------------------------------

(def-test test-lambda-pipeline-freeing (:suite cepl.internals)
  ;; This test is required as we are going to be using lambda-pipelines
  ;; heavily and we need to know that things are being cleaned up properly
  ;; afterwards
  (labels ((count-pipelines ()
             (hash-table-count cepl.pipelines::*gpu-pipeline-specs*)))
    (ensure-cepl
      (let ((before (count-pipelines))
            (pipeline
             (pipeline-g nil
               (lambda-g ((vert :vec4))
                 vert)
               (lambda-g nil
                 (v! 1 0 0 0))))
            (during (count-pipelines)))
        (free pipeline)
        (let ((after (count-pipelines)))
          (is (> during before))
          (is (= before after)))))))

;;------------------------------------------------------------
