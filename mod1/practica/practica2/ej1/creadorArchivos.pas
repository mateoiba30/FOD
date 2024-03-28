program creaderArchivos;

type
    empleado=record
        codigo, nombre:string;
        comision: real;
    end;

    archivo_empleados = file of empleado;

procedure crearBinario(var a1: archivo_empleados; var txt: Text);
var
    emp: empleado;

begin
    reset(txt);
    rewrite(a1); //creamos al archivo

    while(not eof(txt)) do begin
        readln(txt, emp.comision, emp.codigo);
        readln(txt, emp.nombre);
        write(a1, emp);
    end;
    close(a1);
    close(txt);
end;

procedure mostrarBinario(var a1: archivo_empleados);
var
    emp: empleado;

begin
    reset(a1);//lo abrimos en el incio del archivo

    while(not eof(a1)) do begin
        read(a1, emp);
        writeln('codigo: ', emp.codigo, ', comision: ', emp.comision:0:2, ', nombre: ', emp.nombre);
    end;

    close(a1);
end;

var
    a1: archivo_empleados;
    txt: Text;

begin
    assign(a1, 'empleados_compactado');
    //assign(txt, 'empleados_completo.txt');

    //crearBinario(a1, txt);
    mostrarBinario(a1);
end.