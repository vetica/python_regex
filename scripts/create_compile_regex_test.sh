#!/bin/bash
tee ./regextest.py <<"_EOF_"
import time, re
 
text1 = '<h1>match me</h1>'
regex1= '<h1>(.*?)</h1>'
 
text2 = '<h2>match me</h2>'
regex2= '<h2>(.*?)</h2>'
 
text3 = '<h3>match me</h3>'
regex3= '<h3>(.*?)</h3>'
 
re_flags = re.IGNORECASE|re.MULTILINE|re.DOTALL|re.UNICODE
arr =[]
for (step,max_iterations) in [(1,10), (10,100),(100,1000),(1000,10000),(10000,100000),(100000,1000000)]:
    arr += [num for num in range (step, max_iterations + step, step)]
 
for max in arr:
    print('-'*50)
    t1 = time.time()
    re_compiled = re.compile(regex1+str(max), re_flags) # pre-compiling and storing regex
    for _ in range(0, max):
        re_compiled.findall(text1+str(max)+' '+str(_))
    t2 = time.time()
    print("%5i calls in % 8.3f ms - compiled_once"%(max, (t2-t1)*1000.0) )
 
    t3 = time.time()
    regex2_max = regex2+str(max) # doing this here to avoid costs of string concatation in a loop
    for _ in range(0, max):
        re.compile(regex2_max, re_flags).findall(text2+str(max)+' '+str(_))
    t4 = time.time()
    print("%5i calls in % 8.3f ms - compiled_every_call"%(max, (t4-t3)*1000.0) )
 
    t5 = time.time()
    regex3_max = regex3+str(max)# doing this here to avoid costs of string concatation in a loop
    for _ in range(0, max):
        re.findall(regex3_max, text3+str(max)+' '+str(_), re_flags)
    t6 = time.time()
    print("%5i calls in % 8.3f ms - uncompiled"%(max, (t6-t5)*1000.0) )
print('-'*50)
 
_EOF_

