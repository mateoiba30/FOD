program repaso;
uses crt;

const
  HOLA=10;
  //acá declaramos constantes
type
    //acá creamos estructuras, en este ejemplo mostramos como hacer una lista
    lista=^nodo; //esto indica que es un puntero, ponerlo antes que la estructura del nodo
    nodo=record
        n:integer;
        sig:lista;
    end;

//antes del var debemos construir las funciones:
procedure ImprimirLista (l:lista); //estoy haciendo una copia (por valor, no por referencia) del puntero porque no paso 'var l' para que no se guarden los cambios que le hago al puntero
begin
  while (l<>nil)do begin
    writeln('numero: ',l^.n,'  ');
    readkey();
    l:=l^.sig;
  end;
end;

var
  ciudades, habitantes, total, i, j: integer;
  promedio: real;
  //acá declaramos variables locales al main, sin asignarles valores

begin //acá inicia el main
  total:=0;
  For i:=1 to 135 do //así se hace un for
  begin
    write('Ingrese la cantidad de ciudades del partido: ');
    read(ciudades);
    For j:=1 to ciudades do
    Begin
      write('Ingrese la cantidad de habitantes de la ciudad ',j,': ');
      read(habitantes);
      total:=total+habitantes;
    end;
    promedio:=total/ciudades;
    writeln('La cantidad de habitantes promedio de cada ciudad del partido es de: ', promedio:2:2);
    readkey();
  end;

end. //este termina con punto