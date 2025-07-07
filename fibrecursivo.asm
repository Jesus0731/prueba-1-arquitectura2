.data
#fibonacci recursivo
    peticion_recursiva: .asciiz "Ingrese un numero para Fibonacci (Recursivo): "
    resultado_recursiva: .asciiz "Fibonacci (Recursivo) de "
    es_recursiva: .asciiz " es: "
    salto_linea: .asciiz "\n"

.text
.globl main
.globl fib_recursivo # Hace que la función recursiva sea global

main:
    # --- Versión Recursiva ---
    li $v0, 4                 # Syscall para imprimir cadena
    la $a0, peticion_recursiva
    syscall

    li $v0, 5                 # Syscall para leer entero
    syscall
    move $s0, $v0             # Guarda el numero N en $s0 (numero_ingresado)

    move $a0, $s0             # Pasa N como argumento a fib_recursivo
    jal fib_recursivo         # Llama a la función recursiva
    move $s1, $v0             # Guarda el resultado en $s1 (resultado_final)

    # Imprimir resultado recursivo
    li $v0, 4
    la $a0, resultado_recursiva
    syscall

    li $v0, 1
    move $a0, $s0             # Imprime N
    syscall

    li $v0, 4
    la $a0, es_recursiva
    syscall

    li $v0, 1
    move $a0, $s1             # Imprime el resultado
    syscall

    li $v0, 4
    la $a0, salto_linea
    syscall

    # Salir del programa
    li $v0, 10
    syscall


#Función Fibonacci Recursiva (fib_recursivo)
#Argumento:$a0 = n`
#Retorno:$v0 = fib(n)`


fib_recursivo:
    addi $sp, $sp, -12        # Guarda $ra, $s0, $s1 en la pila
    sw $ra, 8($sp)            # Guarda direccion_retorno
    sw $s0, 4($sp)            # Guarda fib_n_menos_1
    sw $s1, 0($sp)            # Guarda valor_n

    move $s1, $a0             # Guarda n en $s1 (valor_n)

    # Casos base:
    # Si n == 0, retorna 0
    li $t0, 0
    beq $a0, $t0, caso_base_0_rec

    # Si n == 1, retorna 1
    li $t0, 1
    beq $a0, $t0, caso_base_1_rec

    # Caso recursivo: fib(n) = fib(n-1) + fib(n-2)
    addi $a0, $s1, -1         # Argumento para fib(n-1)
    jal fib_recursivo         # Llama a fib_recursivo(n-1)
    move $s0, $v0             # Guarda el resultado de fib(n-1) en $s0 (fib_n_menos_1)

    addi $a0, $s1, -2         # Argumento para fib(n-2)
    jal fib_recursivo         # Llama a fib_recursivo(n-2)
    add $v0, $s0, $v0         # Suma fib(n-1) + fib(n-2). El resultado queda en $v0

    # Restaurar registros y retornar
    lw $ra, 8($sp)
    lw $s0, 4($sp)
    lw $s1, 0($sp)
    addi $sp, $sp, 12
    jr $ra

caso_base_0_rec:
    li $v0, 0                 # Retorna 0
    lw $ra, 8($sp)
    lw $s0, 4($sp)
    lw $s1, 0($sp)
    addi $sp, $sp, 12
    jr $ra

caso_base_1_rec:
    li $v0, 1                 # Retorna 1
    lw $ra, 8($sp)
    lw $s0, 4($sp)
    lw $s1, 0($sp)
    addi $sp, $sp, 12
    jr $ra