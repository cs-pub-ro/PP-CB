import os
from collections import defaultdict
import subprocess

values_stage1 = {
            "s1_t1": 15,
            "s1_t2_1": 5,
            "s1_t2_2": 5,
            "s1_t2_3": 5,
            "s1_t2_4": 5,
            "s1_t3": 15,
            "s1_t4": 15,
            "s1_t5": 20,
            "s1_t6": 15
        }

stages_values = {
            "s1": 10,
            "s2": 10,
            "s3": 10,
            "s4": 10,
        }

def test() -> dict:
    results = defaultdict(bool)
    binary_file = "./tests/Main" 
    if not os.path.exists(binary_file):
        print("Compiled binary not found! Please run: make run_test and be sure there were no errors!")
        return results

    ref_files_path = "./tests/ref"
    output_files_path = "./tests/output"
    binary_file = "./tests/Main"

    for _, _, files in os.walk(ref_files_path):
        for f in files:
            test_name = f.split(".")[0]
            ref_file = open(ref_files_path + "/" + f, "rb")
            ref_content = ref_file.read().decode("utf-8")
            ref_file.close()

            test_number = test_name.split("_")[0][-1]
            subtest_number = test_name.split("_")[1][1:]
            if len(test_name.split("_")) == 3:
              cmd = binary_file + " " + str(test_number) + " " + str(subtest_number) + " " + str(test_name.split("_")[2])
            else:
              cmd = binary_file + " " + str(test_number) + " " + str(subtest_number)
            out = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            out_content = out.stdout.read()
            out_file = open(output_files_path + "/" + test_name + ".out", "wb")
            out_file.write(out_content)
            out_file.close()
            results[test_name] = ref_content == out_content.decode("utf-8")

    return results

def summarize_results(results: dict, values: dict, test_meaning: dict) -> None:
    test_results = list(results.items())
    test_results.sort(key=lambda x: (int(x[0].split("_")[0][1:]), int(x[0].split("_")[1][1:])))
    print("="*19)
    print("PP Project Checker")
    print("="*19)
    test_stages = list({x.split("_")[0] for x, y in test_results})
    test_stages.sort()

    test_clusters = defaultdict(list)
    for test, rezult in test_results:
        test_clusters[test.split("_")[0]].append((test, rezult))
    final_score = 0
    for test_stage in test_stages:
        print("Stage " + test_stage[-1])
        print("-"*30)
        obtained_score = 0
        subtests = test_clusters[test_stage]
        for subtest, result in subtests:
            stest = subtest.split("_")[1][1:]
            sstest = "." + subtest.split("_")[2] if len(subtest.split("_")) > 2 else "  "
            stest += sstest
            print(f"Task_{stest}\t\t{values_stage1[subtest] if result else 0}/{values_stage1[subtest]}")
            obtained_score += values_stage1[subtest] if result else 0
        print(f"Total: {obtained_score}")
        print("-"*30)
        final_score += (obtained_score * stages_values[test_stage]) / 100

    print(f"TOTAL: {int(final_score)}/40" + "\n")
    if final_score == 40:
        print("\t\t\t\tCongrats! You chad!")
        print("""\
                                                               
                                       *(//    //                               
                                       ///******,,,                             
                                      **,,,,@*/,,#.,                            
                                    */****,,,,*,@&/,                            
                                   *******,***(%##,.                            
                                  **,,,,*,******,,,                             
                                 ***,,,*,****,***,.*                            
                 .*********/****/***,,,,,,******,,,***********.                 
             ***,,,,,,,*************,,,*,***,**,,,**********,,,,,**/,           
           *,,,,*,,,,***,*************************,,****,***,,,,*,,,,*          
          *,,,,,,*,,,,,,,,,*****,*****************,*,********,*,,,,,,,*         
         *,,,,*,*****,,,,**,**,,*******,*******,,*****,******,,,,,,,,,*         
        ,*,,,,,,*,,*****,***,**,,*******,*,,************,****,*,,,,,,,*         
       ***,,,,,,,*,*****,,******,**,,*****,,****,,,*****,****,**,,,,,,*/        
      .*****,,,,**,***********,,,,,,,,,,,*,*****,,,********,*,,*,,,,,**/.       
       *****,,,*,*****,*********,,,,,,,,,*,,*/**********/*****,*,,**,***        
       ***,,,,******   *********,***********************,,********,,,**,        
      ,*,,,,,********   .*******,,,*************,,,**,**,   ***********         
      ***,*,,***,,****    **,*,*,,*************,,,,*,,**   *******,,,,*         
      /*****,*********.    **/*********,,**,,**,,,***,,.  ****,,*******         
      ,*,,,***,*,,,***     ********,***,,**,,***,,**,,**  ****,****,***         
       ,,,,*,**,,,,,*      ********,,,***,**,**,**,,***   **********,*,         
         *,,,,,,,****/     .****,,****,,**************     **,,,*,*,,*          
           ,,,,,,,,,,**/   ***************.  *,,,**,**  //*,,,,,,,,,            
             ,,,,,,,,,,**.  /*,*,**,,,,,*     *,,**,*  //,,,,,,,,,,             
              ,,,,,,,,**(*   /*,,,*,,*/       /,**,*   (*/,,,,,,,,              
                *.,,,*,*      */,*,**         //****    /,,**,,#                
                               ,,,,,*         ,,,,,.                            
                               /*,,,          ,,,*                              
                                 *,           **.                               
                                                                            
                    """)
    pass

if __name__ == "__main__":
    results = test()
    summarize_results(results, values_stage1, stages_values)
