program ej5;

type
    {EL CODIGO ES UN STRING NO ANDA PORQUE QUIERE TOMAR A TODA LA LÍNEA HASTA EL SALTO DE LÍNEA COMO UN SOLO STRING}
    celular=record
        marca, descripcion, nombre: string;
        precio: real;
        codigo, stock_dis, stock_min: integer;
    end;

    archivo_celulares = file of celular;

{no terminado y no es necesario
procedure leerCelular(var txt: Text, var cel:celular);
var
    i:integer;
    car: char;
    aux: string;

begin
    while(not eof(txt))do begin//leo toods los celus
        For(i=0; i<3; i++) do begin //leo un celu

            car;='';
            while(car <> ' ') do begin//leo el codigo
                read(txt, car);
                cel.codigo:=cel.codigo+car;
            end;

            car:='';
            aux:='';
            while(car <> ' ') do begin//leo el precio
                read(txt, car);
                aux:=aux+car;
            end;          
            cel.precio:=StrToFloat(aux);

            car;='';
            while(car <> ' ') do begin//leo la marca
                read(txt, car);
                cel.marca:=cel.marca+car;
            end;


        end;
    end;
end;
}
procedure cargarCelulares(var a1: archivo_celulares; var txt: Text);
var
    cel: celular;

begin
    rewrite(a1);//creamos el binario
    reset(txt);//abirmos el txt
   
    while (not eof(txt)) do begin

        {EL CODIGO ES UN STRING NO ANDA PORQUE QUIERE TOMAR A TODA LA LÍNEA HASTA EL SALTO DE LÍNEA COMO UN SOLO STRING}
        readln(txt, cel.codigo, cel.precio, cel.marca);
        readln(txt, cel.stock_dis, cel.stock_min, cel.descripcion);
        readln(txt, cel.nombre);
        write(a1, cel);

    end;
    close(a1);
    close(txt);
end;

procedure mostrarCelulares(var a1: archivo_celulares);
var
    cel: celular;

begin
    reset(a1);//lo abrimos en el incio del archivo

    writeln('Celulares: ');
    while(not eof(a1)) do begin
        read(a1, cel);
        writeln('Codigo: ', cel.codigo, ', Marca: ', cel.marca, ', Stock disponible: ', cel.stock_dis, ', Stock minimo: ', cel.stock_min, ', Precio: ',cel.precio:0:2,', Nombre: ', cel.nombre,', Descripcion:', cel.descripcion); //la descripcion ya se le agrego un espacio adelante
    end;

    close(a1);
end;

procedure celularesPocoStock(var a1: archivo_celulares);
var
    cel: celular;

begin
    reset(a1);//lo abrimos en el incio del archivo

    writeln('Celulares con stock menor a su minimo permitido: ');
    while(not eof(a1)) do begin
        read(a1, cel);
        if(cel.stock_dis < cel.stock_min)then
            writeln('Codigo: ', cel.codigo, ', Marca: ', cel.marca, ', Stock disponible: ', cel.stock_dis, ', Stock minimo: ', cel.stock_min, ', Precio: ',cel.precio:0:2,', Nombre: ', cel.nombre,', Descripcion: ', cel.descripcion);
    end;

    close(a1);
end;

procedure buscarDescripcion(var a1: archivo_celulares);
var
    cel: celular;
    cadena:string;
    encontre: boolean;

begin
    encontre:=false;
    reset(a1);//lo abrimos en el incio del archivo

    write('Ingrese una cadena a buscar en las descripciones: ');
    readln(cadena);
    cadena:= ' ' + cadena; //CUANDO LEO LA CADENA DEL TXT LE AGREGA UN ESPACIO AL INICIO.

    while(not eof(a1)) do begin
        read(a1, cel);
        if(cel.descripcion=cadena) then begin
            writeln('Codigo: ', cel.codigo, ', Marca: ', cel.marca, ', Stock disponible: ', cel.stock_dis, ', Stock minimo: ', cel.stock_min, ', Precio: ',cel.precio:0:2,', Nombre: ', cel.nombre,', Descripcion:', cel.descripcion);
            encontre:=true;
        end;
    end;

    if(encontre=false)then
        writeln('No hay coincidencias');

    close(a1);
end;

procedure exportar(var a1: archivo_celulares; var txt2: Text);
var
    cel: celular;

begin
    reset(a1); //abrimos el binario
    rewrite(txt2); //creamos el txt
    while(not eof(a1)) do begin
        read(a1, cel);
        writeln(txt2, cel.codigo,' ', cel.precio:0:2, cel.marca); //antesd e cada string se guarda un espacio, pero eso no pasa con los numeros
        writeln(txt2, cel.stock_dis, ' ',cel.stock_min, cel.descripcion);
        writeln(txt2, cel.nombre);
    end;
    close(a1);
    close(txt2);
end;

var
    terminar: boolean;
    opcion: integer;
    nombre_fisico: string;
    a1: archivo_celulares;
    txt, txt2: Text;

begin
    terminar:=false;

    while(terminar=false) do begin

        writeln('Ingrese una de las siguiente opciones: ');
        writeln('0: FINALIZAR');
        writeln('1: cargar celulares');
        writeln('2: listar poco stock');
        writeln('3: buscar por descripcion');
        writeln('4: exportar archivo a un txt');
        writeln('5: mostrar todos los celulares');

        write('-> ');
        readln(opcion);

        if(opcion<>0) then begin
            write('Ingrese el nombre del ARCHIVO binario: ');
            readln(nombre_fisico);
            assign(a1,nombre_fisico);
            assign(txt, 'celulares.txt');
            assign(txt2, 'celulares2.txt');
        end;

        case opcion of
            0: terminar:=true;
            1: cargarCelulares(a1, txt);
            2: celularesPocoStock(a1);
            3: buscarDescripcion(a1);
            4: exportar(a1, txt2);
            5: mostrarCelulares(a1);
        end;
    end;
end.