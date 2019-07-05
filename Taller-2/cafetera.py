import  skfuzzy  as  fuzz 
import numpy as np
import matplotlib.pyplot as plt

cantidadCafe = 90
temperatura = 120
intensidad = 3
tipo = 'Espresso'


tamano_taza = np.arange(0, 450, 30)
temperatura_ambiental = np.arange(0, 450, 30)
intensidad_cafe = np.arange(0,5, 1)

'''
FUSIFICACIÓN

trimp(x,[a,b,c]) 
x = arreglo al que se le asignará la pertenencia
a = valor inicial de la función de pertenencia
b = valor que tendrá pertenencia 1
c = valor final de la función de pertenencia
retorna un arreglo con los resultados de las funciones de pertenencia del
x ingresado
'''
tamT_lo = fuzz.trimf(tamano_taza, [0, 0, 150])
tamT_md = fuzz.trimf(tamano_taza, [90, 150, 250])
tamT_hi = fuzz.trimf(tamano_taza, [150, 450, 450])

tempA_lo = fuzz.trimf(temperatura_ambiental, [0, 0, 150])
tempA_md = fuzz.trimf(temperatura_ambiental, [90, 150, 250])
tempA_hi = fuzz.trimf(temperatura_ambiental, [150, 450, 450])

intC_lo = fuzz.trimf(intensidad_cafe, [0, 0, 3])
intC_md = fuzz.trimf(intensidad_cafe, [0, 3, 4])
intC_hi = fuzz.trimf(intensidad_cafe, [3, 5, 5])



'''

x_qual = np.arange(0, 11, 1)
x_serv = np.arange(0, 11, 1)
x_tip  = np.arange(0, 26, 1)

# Generate fuzzy membership functions
qual_lo = fuzz.trimf(x_qual, [0, 0, 5])
qual_md = fuzz.trimf(x_qual, [0, 5, 10])
qual_hi = fuzz.trimf(x_qual, [5, 10, 10])
serv_lo = fuzz.trimf(x_serv, [0, 0, 5])
serv_md = fuzz.trimf(x_serv, [0, 5, 10])
serv_hi = fuzz.trimf(x_serv, [5, 10, 10])
tip_lo = fuzz.trimf(x_tip, [0, 0, 13])
tip_md = fuzz.trimf(x_tip, [0, 13, 25])
tip_hi = fuzz.trimf(x_tip, [13, 25, 25])


# We need the activation of our fuzzy membership functions at these values.
# The exact values 6.5 and 9.8 do not exist on our universes...
# This is what fuzz.interp_membership exists for!
qual_level_lo = fuzz.interp_membership(x_qual, qual_lo, 6.5)
qual_level_md = fuzz.interp_membership(x_qual, qual_md, 6.5)
qual_level_hi = fuzz.interp_membership(x_qual, qual_hi, 6.5)

serv_level_lo = fuzz.interp_membership(x_serv, serv_lo, 9.8)
serv_level_md = fuzz.interp_membership(x_serv, serv_md, 9.8)
serv_level_hi = fuzz.interp_membership(x_serv, serv_hi, 9.8)
print(qual_level_hi)
print(qual_level_lo)
print(qual_level_md)





active_rule1  =  np . fmax ( qual_level_lo ,  serv_level_lo )



'''

'''
interp_membership obtiene el valor de pertenencia para el parámetro ingresado
si es que este no se encuentra en el arreglo definido anteriormente (con trimf)
Se debe realizar para cada parámetro que se ingresa al inicio del programa

interp_membership(x, y, z)
x = arreglo con valores posibles de entrada 
y = valores de función de pertenencia
z = valor que se busca en la pertenencia 

'''

nivel_cafe_lo = fuzz.interp_membership(tamano_taza, tamT_lo, cantidadCafe)
nivel_cafe_md = fuzz.interp_membership(tamano_taza, tamT_md, cantidadCafe)
nivel_cafe_hi = fuzz.interp_membership(tamano_taza, tamT_hi, cantidadCafe)

nivel_temp_lo = fuzz.interp_membership(temperatura_ambiental, tempA_lo, temperatura)
nivel_temp_md = fuzz.interp_membership(temperatura_ambiental, tempA_md, temperatura)
nivel_temp_hi = fuzz.interp_membership(temperatura_ambiental, tempA_hi, temperatura)

nivel_int_lo = fuzz.interp_membership(intensidad_cafe, intC_lo, intensidad)
nivel_int_md = fuzz.interp_membership(intensidad_cafe, intC_md, intensidad)
nivel_int_hi = fuzz.interp_membership(intensidad_cafe, intC_hi, intensidad)



'''
SISTEMA DE INFERENCIA (REGLAS)
regla 1: consecuencia: nivel agua poca
regla 2: consecuencia: nivel de agua media
regla 3: consecuencia: nivel de agua mucha

regla 4: consecuencia: cantidad café poca
regla 5: consecuencia: cantidad café media
regla 6: consecuencia: cantidad café mucha

'''
'''
GRÁFICOS
'''
fig, (ax0, ax1, ax2) = plt.subplots(nrows=3, figsize=(8, 9))

ax0.plot(tamano_taza, tamT_lo, 'b', linewidth=1.5, label='Pequeño')
ax0.plot(tamano_taza, tamT_md, 'g', linewidth=1.5, label='Mediano')
ax0.plot(tamano_taza, tamT_hi, 'r', linewidth=1.5, label='Grande')
ax0.set_title('Tamaño Taza')
ax0.legend()

ax1.plot(temperatura_ambiental, tempA_lo, 'b', linewidth=1.5, label='Frío')
ax1.plot(temperatura_ambiental, tempA_md, 'g', linewidth=1.5, label='Cálido')
ax1.plot(temperatura_ambiental, tempA_hi, 'r', linewidth=1.5, label='Caluroso')
ax1.set_title('Temperatura ambiental')
ax1.legend()


ax2.plot(intensidad_cafe, intC_lo, 'b', linewidth=1.5, label='Suave')
ax2.plot(intensidad_cafe, intC_md, 'g', linewidth=1.5, label='Medio')
ax2.plot(intensidad_cafe, intC_hi, 'r', linewidth=1.5, label='Fuerte')
ax2.set_title('Temperatura ambiental')
ax2.legend()

plt.show()


print(tamT_lo)
print(tamT_md)
print(tamT_hi)