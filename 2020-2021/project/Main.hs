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
run_test 3 4 = show $ eval $ similarities_query

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
run_subtest 2 9 1 = write_csv $ projection ["Nume", "Lab (1p)"] $ read_csv hw_grades_csv
run_subtest 2 9 2 = write_csv $ projection ["Nume","Lab (1p)","T1 (0.5p)","T2 (1p)","T3 (1.5p)"] $ read_csv hw_grades_csv

run_subtest 3 1 1 = show $ eval $ FromCSV exam_grades_csv
run_subtest 3 1 2 = show $ eval $ ToCSV $ FromCSV $ lecture_grades_csv
run_subtest 3 1 3 = show $ eval $ AsList "Nume" $ FromCSV hw_grades_csv
run_subtest 3 1 4 = show $ eval $ Sort "Lab (1p)" $ FromCSV hw_grades_csv
run_subtest 3 1 5 = show $ eval $ ValueMap (\x -> if x == "" then "0" else x) $ FromCSV exam_grades_csv
run_subtest 3 1 6 = show $ eval $ RowMap get_hw_grade_total ["Nume", "Total teme"] $ FromCSV hw_grades_csv
run_subtest 3 1 7 = show $ eval $ VUnion (FromCSV hw_grades_csv) (FromCSV hw_grades_csv)
run_subtest 3 1 8 = show $ eval $ HUnion (FromCSV hw_grades_csv) (FromCSV exam_grades_csv)
run_subtest 3 1 9 = show $ eval $ TableJoin "Nume" (FromCSV hw_grades_csv) (FromCSV exam_grades_csv)
run_subtest 3 1 10 = show $ eval $ Cartesian names_only test_schema2 (FromCSV hw_grades_csv) (FromCSV exam_grades_csv)
run_subtest 3 1 11 = show $ eval $ Projection ["Nume", "Lab (1p)"] $ FromCSV hw_grades_csv
run_subtest 3 2 1 = show $ eval $ Filter (Gt "Ex. Scris" (read "1.5" :: Float)) (FromCSV exam_grades_csv)
run_subtest 3 2 2 = show $ eval $ Filter (Eq "Nume" "Lily Luca") (FromCSV exam_grades_csv)
run_subtest 3 2 3 = show $ eval $ Filter (Lt "Nume" "Brian") (FromCSV hw_grades_csv)
run_subtest 3 2 4 = show $ eval $ Filter (In "Q6" [(read "1" :: Float), (read "1" :: Float)]) (FromCSV exam_grades_csv)
run_subtest 3 2 5 = show $ eval $ Filter (FNot $ Eq "T1 (0.5p)" "0.5") (FromCSV hw_grades_csv)
run_subtest 3 2 6 = show $ eval $ Filter ((FieldEq "Q5" "Q6")::(FilterCondition String)) (FromCSV exam_grades_csv)
run_subtest 3 3 1 = show $ eval $ Graph edge_op1 (FromCSV hw_grades_csv)
run_subtest 3 3 2 = show $ eval $ Graph edge_op2 (FromCSV exam_grades_csv)


edge_op1 (n1:l1:_) (n2:l2:_)
            | l1 == l2 = Just l1
            | otherwise = Nothing
edge_op2 l1 l2
    | last l1 == last l2 = Just "identical"
    | (abs $ (read (last l1) :: Float) - (read (last l1) :: Float)) < 0.1 = Just "similar"
    | otherwise = Nothing
test_table1 = take 5 $ read_csv hw_grades_csv
test_table2 = (head $ read_csv hw_grades_csv):(drop 5 $ read_csv hw_grades_csv)
test_table3 = ["Nume","Lab","T1","T2","T3","Ex1","Ex2","Ex3","Ex4"]:(drop 5 $ read_csv hw_grades_csv)
test_schema1 = ["Nume1","Q1","Q2","Q3","Q4","Q5","Q6","Ex. Scris", "Nume2","Q1","Q2","Q3","Q4","Q5","Q6","Ex. Scris"]
test_schema2 = ["Nume1", "Nume2"]
names_only = (\row1 row2 -> [head row1, head row2])