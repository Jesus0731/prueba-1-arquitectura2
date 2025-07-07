.data
    peticion_iterativa: .asciiz "Ingrese un numero para Fibonacci (Iterativo): "
    resultado_iterativa: .asciiz "Fibonacci (Iterativo) de "
    es_iterativa: .asciiz " es: "
    salto_linea: .asciiz "\n"

.text
.globl main
.globl fib_iterativo # Hace que la función iterativa sea global

main:
    # --- Versión Iterativa ---
    li $v0, 4                 # Syscall para imprimir cadena
    la $a0, peticion_iterativa
    syscall

    li $v0, 5                 # Syscall para leer entero
    syscall
    move $s0, $v0             # Guarda el numero N en $s0 (numero_ingresado)

    move $a0, $s0             # Pasa N como argumento a fib_iterativo
    jal fib_iterativo         # Llama a la función iterativa
    move $s1, $v0             # Guarda el resultado en $s1 (resultado_final)

    # Imprimir resultado iterativo
    li $v0, 4
    la $a0, resultado_iterativa
    syscall

    li $v0, 1
    move $a0, $s0             # Imprime N
    syscall

    li $v0, 4
    la $a0, es_iterativa
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


## Función Fibonacci Iterativa (fib_iterativo)
fib_iterativo:
    move $t0, $a0             # Guarda n en $t0 (valor_n)

    # Casos base:
    # Si n == 0, retorna 0
    li $t1, 0
    beq $t0, $t1, caso_base_0_iter

    # Si n == 1, retorna 1
    li $t1, 1
    beq $t0, $t1, caso_base_1_iter

    # Inicialización para la iteración
    li $t1, 0                 # fib_anterior_2 (F_n-2) = 0
    li $t2, 1                 # fib_anterior_1 (F_n-1) = 1
    li $t3, 1                 # Contador del bucle (i = 1, ya cubrimos n=0)

bucle_fib:
    addi $t3, $t3, 1          # i++ (incrementa_contador)
    add $t4, $t1, $t2         # fib_actual = fib_anterior_2 + fib_anterior_1
    move $t1, $t2             # fib_anterior_2 = fib_anterior_1
    move $t2, $t4             # fib_anterior_1 = fib_actual

    bne $t3, $t0, bucle_fib   # Si i != n, continúa el bucle

    move $v0, $t4             # El resultado final es fib_actual ($t4)
    jr $ra

caso_base_0_iter:
    li $v0, 0                 # Retorna 0
    jr $ra

caso_base_1_iter:
    li $v0, 1                 # Retorna 1
    jr $ra