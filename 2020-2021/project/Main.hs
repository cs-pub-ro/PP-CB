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
run_test 2 3 = write_csv $ vmap (\x -> if x == "" then "0" else x) $ read_csv exam_grades_csv
run_test 2 4 = write_csv $ rmap get_hw_grade_total ["Nume", "Total teme"] $ read_csv hw_grades_csv
run_test 2 7 = write_csv $ tjoin "Nume" (read_csv hw_grades_csv) (read_csv exam_grades_csv)

run_subtest 1 2 1 = show $ get_passed_students_num exam_grades
run_subtest 1 2 2 = printf "%.2f" $ get_passed_students_percentage exam_grades
run_subtest 1 2 3 = printf "%.2f" $ get_exam_avg exam_grades
run_subtest 1 2 4 = show $ get_passed_hw_num hw_grades
run_subtest 2 1 1 = show $ as_list "Nume" $ read_csv hw_grades_csv
run_subtest 2 1 2 = show $ as_list "Ex. Scris" $ read_csv exam_grades_csv
run_subtest 2 2 1 = write_csv $ tsort "Lab (1p)" $ read_csv hw_grades_csv
run_subtest 2 2 2 = write_csv $ tsort "13.3" $ read_csv lecture_grades_csv
run_subtest 2 5 1 = write_csv $ vunion test_table1 test_table2
run_subtest 2 5 2 = write_csv $ vunion test_table1 test_table3
run_subtest 2 6 1 = write_csv $ hunion (take 100 $ read_csv hw_grades_csv) (take 100 $ read_csv exam_grades_csv)
run_subtest 2 6 2 = write_csv $ hunion (read_csv hw_grades_csv) (read_csv exam_grades_csv)
run_subtest 2 8 1 = write_csv $ cartesian (++) test_schema1 (take 5 $ read_csv hw_grades_csv) (take 10 $ read_csv hw_grades_csv)
run_subtest 2 8 2 = write_csv $ cartesian names_only test_schema2 (take 5 $ read_csv hw_grades_csv) (take 10 $ read_csv exam_grades_csv)
    where
        names_only = (\row1 row2 -> [head row1, head row2])
run_subtest 2 9 1 = write_csv $ projection ["Nume", "Lab (1p)"] $ read_csv hw_grades_csv
run_subtest 2 9 2 = write_csv $ projection ["Nume","Lab (1p)","T1 (0.5p)","T2 (1p)","T3 (1.5p)"] $ read_csv hw_grades_csv

test_table1 = take 5 $ read_csv hw_grades_csv
test_table2 = (head $ read_csv hw_grades_csv):(drop 5 $ read_csv hw_grades_csv)
test_table3 = ["Nume","Lab","T1","T2","T3","Ex1","Ex2","Ex3","Ex4"]:(drop 5 $ read_csv hw_grades_csv)
test_schema1 = ["Nume1","Q1","Q2","Q3","Q4","Q5","Q6","Ex. Scris", "Nume2","Q1","Q2","Q3","Q4","Q5","Q6","Ex. Scris"]
test_schema2 = ["Nume1", "Nume2"]