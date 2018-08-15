require 'httparty'

URL='https://sepa.utem.cl/rest/api/v1'
AUTH = {username: 'EH9550bn6q', password: '290bf40f3a27671b71ccf2f454533607'}

#Inicio de sesión

 def sesion
   print "Ingrese rut "
   rut = gets
   print "Ingrese contraseña"
   password = gets
   sesion_end_point = '/sepa/autenticar'
   respuesta = HTTParty.get(URI.encode(URL+sesion_end_point+rut+password), basic_auth: AUTH)
   if respuesta.code ==404
     puts "error"
   else
     puts "bienvenido"
   end
 end

#Promedio último año

 def promramoultimoano
   guardar = 0
   print "Ingrese rut "
   rut = gets.chomp
   promultimo_end_point= "/docencia/estudiantes/#{rut}/asignaturas"
   respuesta = HTTParty.get(URI.encode(URL+promultimo_end_point), basic_auth: AUTH)
   lista= []
   lista2 = []
   variable=[]
   respuesta.each do |actual|
     lista = actual['curso']['anio']
     guardar = actual['curso']['anio']+1
     if lista < guardar
        guardar = lista
        guardar = guardar + 1
     end
   end
   respuesta.each do |actual|
     if actual['curso']['anio'] == lista
       lista2 << actual['curso']['asignatura']['nombre']
       lista2 << actual['nota']
     end
   end
   File.open('archivo.txt',"w") do |f|
     f.puts lista2
   end
   p lista2
 end

#Promedio general de estudiante

 def promedio
   print "Ingrese rut "
   rut = gets.chomp
    estudiantes_end_point= "/utem/estudiantes/#{rut}"
    #rut = '/187401720'
    respuesta = HTTParty.get(URI.encode(URL+estudiantes_end_point), basic_auth: AUTH)
    prom = respuesta['promedioNotas']
      File.open('archivo.txt',"w") do |f|
        f.puts prom
      end
  end

#Promedio por semestre hasta el último

def promediossemestre
  promedios = []
  semestre  = []
  año = []
  notas = []
  print "Ingrese rut "
  rut = gets.chomp
  promultimo_end_point= "/docencia/estudiantes/#{rut}/asignaturas"
  respuesta = HTTParty.get(URI.encode(URL+promultimo_end_point), basic_auth: AUTH)
  respuesta.each do |actual|
    año << actual  ['curso']['anio']
    semestre << actual  ['curso']['semestre']
    notas << actual['nota']
  end
  largo = año.size
  año_inicio = año [0]
  suma= 0
  contador = 0
  semestre_inicio = 1
  for i in (0..largo)
      if (año_inicio == año [i] && semestre_inicio == semestre[i])
         suma = suma + notas[i]
         contador = contador +1
      else
         suma / contador
         promedios << suma/ contador
         año_inicio = año [i]
         suma =   notas[i]
         contador = 1
         if semestre_inicio == 1
            semestre_inicio =2
         else
            semestre_inicio = 1
         end
      end
   end
   File.open('archivo.txt',"w") do |f|
     f.puts promedios
   end
    p promedios
end


def menu
print "Tarea 5 Ingenieria de Software\n"
print "1.- Iniciar Sesion\n"
print "2.- Promedio de cada ramo cursado el último año\n"
print "3.- Promedio de cada semestre\n"
print "4.- Promedio general\n"
print "5.- Salir\n"
print "0.- Volver al menu\n"
opcion = gets.to_i
case opcion
when 1
  sesion
  menu
when 2
  promramoultimoano
  menu
  print "\n"
when 3
  promediossemestre
  menu
  print "\n"
when 4
  promedio
  menu
  print "\n"
when 5
  print "Adios\n"
when 0
  menu

end
end

menu
