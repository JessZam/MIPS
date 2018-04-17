################################################
#                                              #
#  Name:Jesslyn Zamora                         #
#  Class: CDA 3100                             #
#  Assignment 5: Determine the sum, min, max,  #	
#		 mean, and variance.                   #
#                                              #
################################################

                .data
msg1:   .asciiz "Enter integer values, one per line, terminated by a negative value.\n"
sum:    .asciiz "Sum is: "
min:    .asciiz "\nMin is: "
max:    .asciiz "\nMax is: "
mean:   .asciiz "\nMean is: "
var:    .asciiz "\nVariance is: "
stop:   .asciiz "\nThe program has stopped."

        .text
        .globl main

        #$s1 current number
        #$s2 stores sum
        #$s3 stores the number of elements
        #$s4 current min
        #$s5 current max
        #$s6 squared sum

main:
        li      $v0,4           #tell syscall to print out string
        la      $a0,msg1        #load the address of the string
        syscall                 #prints out the message
        
        lui     $s4,0x7fff      #load upper immediate
        ori     $s4,$s4,0xffff  #load lower bits
        
        move    $s2,$zero       #sets the sum to zero   
        move    $s3,$zero       #sets the number of elements to zero
        move    $s5,$zero       #set max to zero

        li      $v0,5           #tell syscall to read in an integer
        syscall                 #read in integer
        move    $t1,$v0         #move the integer
loop:
        move    $s1,$t1         #move read in number to $s1
        bltz    $s1,summary     #if below zero go to summary

        add     $s2,$s2,$s1     #add the number to the sum
        addi    $s3,$s3,1       #add one to the number of elements

        mult    $s1,$s1         #squares the numbers
        mflo    $t4             #puts the squared number intp $t4
        add     $s6,$s6,$t4     #adds the squared 

        slt     $t1,$s1,$s4     #check if current num is less than min and if not then don't change
        beq     $t1,$zero,kmin  #checks if current num is not less than min
        move    $s4,$s1         #else change the min

kmin:
        slt     $t1,$s5,$s1     #checks if max is less than the current number
        beq     $t1,$zero,kmax  #checks if current num is not less than $s1
        move    $s5,$s1         #else change max

kmax:

        li      $v0,5           #tell syscall to read in integer
        syscall                 #read in the integer
        move    $t1,$v0         #moves the number to $t0 so we can use it
        j       loop            #go to the top of the loop
                
summary:                        
        li      $v0,4           #tell syscall to print out string
        la      $a0,sum         #load the address of the string
        syscall                 #print out the string

        li      $v0,1           #tell syscall to print out integer
        move    $a0,$s2         #move the sum 
        syscall                 #print ou the sum

        li      $v0,4           #tell syscall to print out string
        la      $a0,min         #load address of the string
        syscall                 #print out the string

        li      $v0,1           #tell syscall to print out integer
        move    $a0,$s4         #move the minimun value
        syscall                 #print out the min

        li      $v0,4           #tell syscall to print out a string
        la      $a0,max         #load the address of the string  
        syscall                 #print out the string

        li      $v0,1           #tell syscall to print out integer
        move    $a0,$s5         #move the maximum number
        syscall                 #print out the maximum number

        li      $v0,4           #tell syscall to print out string
        la      $a0,mean        #load address of the string
        syscall                 #print out the string

        mtc1    $s2,$f3         #move the sum into a floating point register
        cvt.s.w $f3,$f3         #convert the int into single and put into a floating point register

        mtc1    $s3,$f4         #move the number of integers into floating point register
        cvt.s.w $f4,$f4         #convert into single and store into floating point register

        div.s   $f3,$f3,$f4     #divide both the sum by the count to get single floating point mean

        li      $v0,2           #tell syscall to print out a floating point number
        mov.s   $f12,$f3        #move the number to print
        syscall                 #print out the mean

variance:

        li      $v0,4           #tell syscall to print out a string
        la      $a0,var         #load address of string
        syscall                 #print out string

        mtc1    $s6,$f5         #move the squared sum into a floating point register
        cvt.s.w $f5,$f5         #convert it and store it

        mtc1    $s3,$f6         #move the amount of numbers into floating point register
        cvt.s.w $f6,$f6         #convert and store

        div.s   $f5,$f5,$f6     #floating point division between the squared sum and amount of numbers

        mul.s   $f3,$f3,$f3     #floating point multiplication to square the mean

        sub.s   $f5,$f5,$f3     #floating point subratraction between the division quotient and the squared mean

        li      $v0,2           #tell syscall to print out a floating point number
        mov.s   $f12,$f5        #move the number to print
        syscall

        li      $v0,4           #tell syscall to print out string
        la      $a0,stop        #load address of the string
        syscall                 #print string

        jr      $ra             #ends the program

