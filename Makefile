OBJS = parser.cmo lexer.cmo pretty.cmo codegen.cmo toplevel.cmo main.cmo

rhine : $(OBJS)
	ocamlfind ocamlc -package llvm -package llvm.executionengine -linkpkg $(OBJS) -o rhine
lexer.ml : lexer.mll
	ocamllex lexer.mll
parser.ml parser.mli : parser.mly
	ocamlyacc parser.mly
codegen.cmo: codegen.ml
	ocamlfind ocamlc -c -package llvm -linkpkg $<
toplevel.cmo: toplevel.ml
	ocamlfind ocamlc -c -package llvm -linkpkg $<
%.cmo : %.ml
	ocamlc -c $<
%.cmi : %.mli
	ocamlc -c $<
clean :
	rm -f rhine parser.ml parser.mli lexer.ml *.cmo *.cmi *.cmx

codegen.cmo : pretty.cmo ast.cmi
codegen.cmx : pretty.cmx ast.cmi
lexer.cmo : parser.cmi
lexer.cmx : parser.cmx
main.cmo : toplevel.cmo pretty.cmo parser.cmi lexer.cmo ast.cmi
main.cmx : toplevel.cmx pretty.cmx parser.cmx lexer.cmx ast.cmi
parser.cmo : ast.cmi parser.cmi
parser.cmx : ast.cmi parser.cmi
pretty.cmo : ast.cmi
pretty.cmx : ast.cmi
toplevel.cmo : codegen.cmo ast.cmi
toplevel.cmx : codegen.cmx ast.cmx
ast.cmi :
parser.cmi : ast.cmi
