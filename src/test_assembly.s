

lui     x1, 460290
ori     x1, x1, 129
addi    x2, x0, -3    
addi    x3, x0, 8      
addi    x4, x0, 2     

sw      x1, 0(x0)    
sh      x2, 4(x0)    
sb      x3, 8(x0)   
lw      x5, 0(x0)   
lh      x6, 2(x0)    
lb      x7, 4(x0)    
lhu     x8, 7(x0)    
lbu     x9, 9(x0)    

add     x10, x1, x2    
sub     x11, x3, x4   
and     x12, x1, x3   
or      x13, x2, x4   
xor     x14, x1, x3  

slli    x15, x1, 2    
srli    x16, x3, 1     
srai    x17, x2, 1     
sll     x18, x1, x4   
srl     x19, x3, x4   
sra     x20, x2, x4   

lui     x21, 0x12345  
auipc   x22, 0x1000   

slt     x23, x2, x1   
sltu    x24, x2, x1   
slti    x25, x1, 10   
sltiu   x26, x1, 10   


beq     x0, x0, beq_target
addi    x27, x0, 1    

beq_target:
bne     x1, x2, bne_target
addi    x27, x0, 2    

bne_target:
blt     x2, x1, blt_target
addi    x27, x0, 3    

blt_target:
bge     x1, x2, bge_target
addi    x27, x0, 4    

bge_target:
bltu    x1, x3, bltu_target
addi    x27, x0, 5     

bltu_target:
bgeu    x3, x1, bgeu_target
addi    x27, x0, 6  

bgeu_target:
jal     x28, jal_target
addi    x29, x0, 7     

jal_target:
jalr    x30, 184(x0)    
addi    x29, x0, 67
addi    x29, x0, 68
ori     x29, x0, 69
xori    x27, x29, 31
andi    x24, x27, 29

infinite_loop:
jal     x0, infinite_loop     # Loop forever