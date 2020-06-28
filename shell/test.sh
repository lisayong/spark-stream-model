#!/bin/bash
 xpath=$(dirname "$PWD")
 today=$2
 subpat=$1
 bashpath="$xpath$subpat"
 main(){
   if [ ! "$today" ]; then
       today=`date -d today +"%Y-%m-%d"`
   else
     echo "${today}" | egrep "([0-9][0-9][0-9][0-9])-(0[1-9]|[1][0-2])-(0[1-9]|[1-2][0-9]|3[0-1])"
     if [ $? != 0 ]; then
         echo "==============时间输入问题error"
         exit -1
     fi
   fi
   echo "=============start================"
   echo "path===============================$bashpath"
   echo "today==============================$today"
      run_cmd=" --master yarn \
	           --deploy-mode client \
             --driver-memory 4g \
             --driver-cores 2 \
			       --name testmodel \
             --executor-memory 36g \
             --num-executors 10 \
             --executor-cores 6 \
             --properties-file $xpath/src/main/resources/exteral.properties \
             --conf spark.executor.extraJavaOptions=-XX:+UseG1GC \
             --class com.apache.bigdata.spark.service.platform.test $bashpath "
    echo $run_cmd
   spark-submit ${run_cmd}
   if [ $? = 0 ]; then
       echo "==============success================="
   else
     echo "==============fail================="
     echo "==================================${xxxx}"
     exit -1
   fi
   echo "==============end================="
}
main