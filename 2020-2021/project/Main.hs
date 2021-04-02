{-
    PP Project 2021
    
	DO NOT MODIFY! This is used by the checker.
    To run one test and check its output, load main.hs into ghci and use command:
    run_test taskset_number task_number [subtask_number]
        where subtask_number is used only for task_number 2
-}


module Main where

import System.Environment
import System.IO
import Text.Printf

import Tasks
import Dataset

main = do
    args <- getArgs
    case args of
        [] -> error "No test specified!"
        [_] -> error "No subtest specified!"
        stage:test:[] -> putStr $ run_test (read stage :: Integer) (read test :: Integer)
        stage:test:subtest:[] -> putStr $ run_subtest (read stage :: Integer) (read test :: Integer) (read subtest :: Integer)
        _ -> error "Too many args"

run_test 1 1 = show $ compute_exam_grades exam_grades
run_test 1 3 = show $ get_avg_responses_per_qs exam_grades
run_test 1 4 = show $ get_exam_summary exam_grades
run_test 1 5 = show $ get_ranking exam_grades
run_test 1 6 = show $ get_exam_diff_table exam_grades

run_subtest 1 2 1 = show $ get_passed_students_num exam_grades
run_subtest 1 2 2 = printf "%.2f" $ get_passed_students_percentage exam_grades
run_subtest 1 2 3 = printf "%.2f" $ get_exam_avg exam_grades
run_subtest 1 2 4 = show $ get_passed_hw_num hw_grades

