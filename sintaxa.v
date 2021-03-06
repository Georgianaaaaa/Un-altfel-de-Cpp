Require Import Strings.String.
Delimit Scope string_scope with string.
Local Open Scope string_scope.
Require Import Arith.
Require Import Ascii.
Require Import Bool.
Require Import Coq.Strings.Byte.
Scheme Equality for string.



Inductive ErrorNat :=
  | error_nat : ErrorNat
  | num : nat -> ErrorNat.

Inductive ErrorBool :=
  | error_bool : ErrorBool
  | boolean : bool -> ErrorBool.

(*TIPUL CHAR*)

Inductive ErrorString :=
  | error_string : ErrorString
  | stringg : string -> ErrorString.
 


Coercion num : nat >-> ErrorNat.
Coercion boolean : bool >-> ErrorBool.
Coercion stringg : string >-> ErrorString.



(*EXPRESII ARITMETICE*)

Inductive AExp :=
| avar : string -> AExp
| anum : ErrorNat -> AExp
| aplus : AExp -> AExp -> AExp
| amul : AExp -> AExp -> AExp
| aminus : AExp -> AExp -> AExp
| adiv : AExp -> AExp -> AExp
| amodulo : AExp -> AExp -> AExp.


Coercion anum : ErrorNat >-> AExp.
Coercion avar : string >-> AExp.


Notation "A +' B" := (aplus A B) (at level 60, right associativity).
Notation "A *' B" := (amul A B) (at level 58, left associativity).
Notation "A -' B" := (aminus A B) (at level 50, left associativity).
Notation "A /' B" := (adiv A B) (at level 40, left associativity).
Notation "A %' B" := (amodulo A B) (at level 50, left associativity).

Compute 1 +' 2.
Compute "x" -' 6.
Compute 5 *' "x" /' 8.
Compute 35 %' "i".



Definition plus_ErrorNat (n1 n2 : ErrorNat) : ErrorNat :=
  match n1, n2 with
    | error_nat, _ => error_nat
    | _, error_nat => error_nat
    | num v1, num v2 => num (v1 + v2)
    end.

Definition minus_ErrorNat (n1 n2 : ErrorNat) : ErrorNat :=
  match n1, n2 with
    | error_nat, _ => error_nat
    | _, error_nat => error_nat
    | num n1, num n2 => if Nat.ltb n1 n2
                        then error_nat
                        else num (n1 - n2)
    end.

Definition mul_ErrorNat (n1 n2 : ErrorNat) : ErrorNat :=
  match n1, n2 with
    | error_nat, _ => error_nat
    | _, error_nat => error_nat
    | num v1, num v2 => num (v1 * v2)
    end.

Definition div_ErrorNat (n1 n2 : ErrorNat) : ErrorNat :=
  match n1, n2 with
    | error_nat, _ => error_nat
    | _, error_nat => error_nat
    | _, num 0 => error_nat
    | num v1, num v2 => num (Nat.div v1 v2)
    end.

Definition modulo_ErrorNat (n1 n2 : ErrorNat) : ErrorNat :=
  match n1, n2 with
    | error_nat, _ => error_nat
    | _, error_nat => error_nat
    | _, num 0 => error_nat
    | num v1, num v2 => num (Nat.modulo v1 v2)
    end.

(*EXPRESII BOOLEENE*)

Inductive BExp :=
| berror : BExp
| btrue : BExp
| bfalse : BExp
| bnot : BExp -> BExp
| band : BExp -> BExp -> BExp
| bor : BExp -> BExp -> BExp
| blessthan : AExp -> AExp -> BExp
| bgreaterthan : AExp -> AExp -> BExp
| bequal : AExp -> AExp -> BExp
| bvar: string -> BExp.

Coercion bvar : string >-> BExp.

Notation "! A" := (bnot A) (at level 70).
Notation "A 'and'' B" := (band A B) (at level 80).
Notation "A <' B" := (blessthan A B) (at level 70).
Notation "A >' B" := (bgreaterthan A B) (at level 70).
Notation "A 'or'' B" := (bor A B) (at level 85, right associativity).
Notation " A == B ":=(bequal A B) (at level 80).

Check btrue or' ! bfalse.
Check ! ("x" <' 10). 
Check btrue and' ("n" >' 0).
Check "x" >' 10 and' (15 <' "m" -' 2).



Definition blessthan_ErrorBool (n1 n2 : ErrorNat) : ErrorBool :=
  match n1, n2 with
    | error_nat, _ => error_bool
    | _, error_nat => error_bool
    | num v1, num v2 => boolean (Nat.ltb v1 v2)
    end.

Definition greaterthan_ErrorBool (n1 n2 : ErrorNat) : ErrorBool :=
  match n1, n2 with
    | error_nat, _ => error_bool
    | _, error_nat => error_bool
    | num v1, num v2 => boolean (negb (Nat.ltb v1 v2))
    end.

Definition bnot_ErrorBool (n :ErrorBool) : ErrorBool :=
  match n with
    | error_bool => error_bool
    | boolean v => boolean (negb v)
    end.

Definition band_ErrorBool (n1 n2 : ErrorBool) : ErrorBool :=
  match n1, n2 with
    | error_bool, _ => error_bool
    | _, error_bool => error_bool
    | boolean v1, boolean v2 => boolean (andb v1 v2)
    end.

Definition bor_ErrorBool (n1 n2 : ErrorBool) : ErrorBool :=
  match n1, n2 with
    | error_bool, _ => error_bool
    | _, error_bool => error_bool
    | boolean v1, boolean v2 => boolean (orb v1 v2)
    end.

Definition bequal_ErrorBool (n1 n2 : ErrorNat) : ErrorBool :=
  match n1, n2 with
    | error_nat, _ => error_bool
    | _, error_nat => error_bool
    | num v1, num v2 => boolean (Nat.eqb v1 v2)
    end.


(*OPERATII PE STRING-URI*)

Inductive Strings :=
| string_var : string -> Strings
| string_str : ErrorString -> Strings
| strlen : ErrorString -> Strings
| strcat : ErrorString -> ErrorString -> Strings
| strcmp : ErrorString -> ErrorString -> Strings.


Coercion string_var: string >->Strings.

Notation " ~ A ~ ":=(strlen A) (at level 60).
Notation " A +/ B " :=(strcat A B) (at level 60).
Notation " A ? B ":=(strcmp A B) (at level 60).


Check " ~ tema ~ ".
Check "proiect" +/ "plp".
Check "a" ? "b".

Definition string_length (s : ErrorString) : ErrorNat :=
  match s with 
    | error_string => error_nat
    | stringg v1 => length v1
end.

Compute string_length "mama".



Definition concat_string (s1 : ErrorString) (s2 : ErrorString) : ErrorString :=
    match s1,s2 with 
    | error_string, _ => error_string
    | _, error_string => error_string
    | stringg v1, stringg v2 => v1 ++ v2
end.

Compute concat_string "a" "b".


Definition strcmp_string (s1 : ErrorString) (s2 : ErrorString) : ErrorString :=
    match s1,s2 with 
    | error_string, _ => error_string
    | _, error_string => error_string
    | stringg v1 , stringg v2 =>if (Nat.leb(length v1) (length v2))
                                then v2
                                else v1
end.
Compute strcmp_string "abcd" "abc".

(*VECTORI*)

Require Setoid.
Require Import PeanoNat Le Gt Minus Bool Lt.
Set Implicit Arguments.
Open Scope list_scope.

Inductive ErrorArray :=
| err_array : ErrorArray
| nat_array : string -> nat -> (list nat) -> ErrorArray
| bool_array : string -> nat -> (list bool) -> ErrorArray
| string_array : string -> nat -> (list string) -> ErrorArray.


Notation "[ ]" := nil (format "[ ]") : list_scope.
Notation "[ x ]" := (cons x nil) : list_scope. 
Notation "[ x , y , .. , z ]" := (cons x (cons y .. (cons z nil) ..)) : list_scope. 
Section Lists. 
Check [ 1 , 2 , 3 , 4 ]. 
Check [ ]. 
Check [true , false]. 
Check ["a" , "b"]. 
Notation "A [[ N ]] n:= S ":=(nat_array A N S) (at level 20).
Notation "A [[ N ]] b:= S ":=(bool_array A N S) (at level 20).
Notation "A [[ N ]] s:= S ":=(string_array A N S) (at level 20).

Check ("v"[[ 10 ]] n:= [ 1 , 2 , 3 ]).
Check ("booleean" [[ 5 ]] b:= [ true , false]).
Check ("siruri" [[ 10 ]] s:= [ "proiect" , "plp" , "sintaxa"]).

(*OPERATII CU VECTORI*)

Inductive Array_op :=
| arr_const : ErrorArray -> Array_op
| arr_var : string -> Array_op
| array_length : ErrorArray -> Array_op
| add_elem_nat : ErrorArray -> nat -> Array_op
| delete_elem : ErrorArray -> nat -> Array_op
| last_array : ErrorArray -> Array_op
.

Notation " 'lg' X ":=(array_length X)(at level 90).
Check (lg "v" [[ 10 ]]n:= [ 1 , 2 , 3 ]).

Notation " 'add' X 'to' A ":=(add_elem_nat A X)(at level 90).
Check add 7 to "v" [[ 10 ]]n:= [ 1 , 2 , 3 ].

(*POINTERI SI REFERINTE*)

Inductive pointer :=
| errpointer : pointer
| null_pointer : pointer
| Pointer : string -> pointer
| reference : string -> pointer.

Scheme Equality for pointer.

Notation " * S " := (Pointer S)(at level 60).
Notation " & S " := (reference S )(at level 60).
Check * "s".
Check & "s".



Inductive Stmt :=
| nat_decl : string -> AExp -> Stmt
| bool_decl : string -> BExp -> Stmt
| string_decl : string -> string -> Stmt
| nat_assignment : string -> AExp -> Stmt
| bool_assignment : string -> BExp -> Stmt
| string_assignment : string -> AExp -> Stmt
| sequence : Stmt -> Stmt -> Stmt
| ifthen : BExp -> Stmt -> Stmt
| ifthenelse : BExp -> Stmt -> Stmt -> Stmt
| while : BExp -> Stmt -> Stmt
| FOR : Stmt -> BExp -> Stmt -> Stmt
| nat_array_decl : string -> nat -> Stmt
| bool_array_decl : string -> nat -> Stmt
| string_array_decl : string -> nat -> Stmt
| nat_array_assign : string -> nat -> (list nat) -> Stmt
| bool_array_assign : string -> nat -> (list bool) -> Stmt
| string_array_assign : string -> nat -> (list string) -> Stmt
| pointer_decl : string -> string -> Stmt
| reference_decl : string -> string -> Stmt
| pointer_assignment : string -> string -> Stmt
| reference_assignment : string -> string -> Stmt
| citeste : string -> Stmt
| afiseaza : string -> Stmt
| break : Stmt
| continue : Stmt
| apel_fct : string -> list string -> Stmt
| switch_case : AExp -> list cases -> Stmt
with cases :=
| case : AExp -> Stmt -> cases
| default_case : Stmt -> cases.



Inductive Program :=
| secv : Program -> Program -> Program
| nat_decl_def : string -> Program
| bool_decl_def : string -> Program
| string_decl_def : string -> Program
| array_decl_def : string -> nat -> Program
| pointer_decl_def : string -> Program
| main_fct : Stmt -> Program
| fct : string -> list string -> Stmt -> Program.


Notation "X :n= A" := (nat_assignment X A)(at level 90).
Check "x" :n= "i" +' 10.

Notation "X :b= A" := (bool_assignment X A)(at level 90).
Check "ok" :b= btrue.

Notation "X :s= A" := (string_assignment X A)(at level 90).
Check "m" :s= "mama".

Notation "'Nat' X ::= A" := (nat_decl X A)(at level 90).
Check Nat "i" ::=10.

Notation "'Bool' X ::= A" := (bool_decl X A)(at level 90).
Check Bool "ok" ::= btrue .

Notation "'String' X ::= A " := (string_decl X A)(at level 90).
Check String "ab" ::= "ba" .

Notation "S1 ;; S2" := (sequence S1 S2) (at level 90).
Check ( Nat "n" ::= 10 ;; String "y" ::= "ab" ).

Notation "'If' B 'Then' S1 'Else' S2 'End'" := (ifthenelse B S1 S2) (at level 97).
Notation "'While' ( A ){ B } " := (while A B) (at level 50).
Notation "'If' B 'Then' S  'End'" := (ifthen B S) (at level 97).
Notation "'For' ( A ; B ; C ) { S }" := (A ;; while B ( S ;; C )) (at level 97).

Notation " 'Nat' X [[[ A ]]] ":=(nat_array_decl X A)(at level 90).
Check Nat "v" [[[ 10 ]]].

Notation " 'Bool' X [[[ A ]]] ":=(bool_array_decl X A)(at level 90).
Check Bool "b" [[[ 2 ]]].

Notation "'String' X [[[ A ]]]":=(string_array_decl X A)(at level 90).
Check String "s"  [[[ 5 ]]].

Notation "X [[[ N ]]] n:-> A ":=(nat_array_assign X N A)(at level 90).
Check "v"[[[ 2 ]]] n:-> [ 1 , 2 ].

Notation "X [[[ N ]]] b:-> A ":=(bool_array_assign X N A)(at level 90).
Check "b" [[[ 2 ]]] b:-> [ true , false ].

Notation "X [[[ N ]]] s:-> A ":=(string_array_assign X N A)(at level 90).
Check "s" [[[ 10 ]]] s:-> [ "a" , "b" ].

Notation " cin>> A ":=(citeste A) (at level 90).
Check cin>> "x".

Notation " cout<< A ":=(afiseaza A) (at level 90).
Check cout<< "x".

Notation " 'call' X ((( S1 , .. , Sn )))" := (apel_fct X (cons S1 .. (cons Sn nil) .. ) ) (at level 90).
Check call "suma_pare" ((("a" , "b" ))).
Notation " 'call' X ((( )))":=(apel_fct X nil)(at level 90).
Check call "cmmdc" ((( ))).

Notation " 'NAT' X ":=(nat_decl_def X)(at level 90).
Check NAT "x".

Notation " 'BOOL' X ":=(bool_decl_def X)(at level 90).
Check BOOL "b".

Notation " 'STRING' X":=(string_decl_def X)(at level 90).
Check STRING "s".

Notation " S1 ;;; S2 ":=(secv S1 S2)(at level 90).
Notation " 'int_main()' { S } ":=(main_fct S)(at level 90).
Notation " 'int_functie' X (( N1 , .. , Nn )){ S }" := (fct X (cons N1 .. (cons Nn nil) .. ) S)(at level 90).
Check (int_functie "impar" (( "x" , "y" )){ "x" :n= "y" +' 10 } ).
Notation " 'int_functie' X (( )){ S } ":=(fct X nil S)(at level 90).
Check int_functie "alabala" (( )){ If ("i" >' "x") 
                              Then "ok" :b= bfalse
                              Else "sum" :n= "sum" +' "x" 
                              End }.
 

Notation " 'default:{' S }; " := (default_case S) (at level 90).
Notation " 'case(' S ):{ A }; " := (case S A) (at level 90).
Notation " 'Switch(' A ){ S1 .. Sn '}endd' " := (switch_case A (cons S1 .. (cons Sn nil) .. ) ) (at level 90).

Check  Switch( "a" ){ default:{ "a" :n=0 }; 
                     case( 1 ):{ "a" :n=1 };
                     case( 2 ):{ "b" :b=bfalse}; }endd.

Notation " X :== '*' A ":=(pointer_decl X A)(at level 90).
Check "a" :== * "p".

Notation " X :== '&' A ":=(reference_decl X A)(at level 90).
Check "r" :== & "ref".

Notation " X p:== '*' A ":=(pointer_assignment X A)(at level 90).
Check "p" p:== * "ab".

Notation " X r:== '&' A ":=(reference_assignment X A)(at level 90).
Check "r" r:== & "cd".

Notation " 'pointer' '*' X ":=(pointer_decl_def X)(at level 90).
Check pointer * "p".

Inductive ValueTypes :=
| default_nat : ValueTypes
| default_bool : ValueTypes
| default_string : ValueTypes
| err_undeclared : ValueTypes
| err_assignment : ValueTypes
| natural : ErrorNat -> ValueTypes
| res_boolean : ErrorBool -> ValueTypes
| res_stringg : ErrorString -> ValueTypes
| arr_value : ErrorArray -> ValueTypes
| code : Stmt -> ValueTypes.
 
Coercion code : Stmt >-> ValueTypes.

Check 7.
Check true.
Check "ana".

(*Scheme Equality for ValueTypes.*)


Check ( Nat "x" ::= 3 ;; 
        Nat "i"::= 0 ;;
        Bool "ok" ::= btrue ;;
        Nat "sum" ::=0 ;;
       For ( Nat "i" ::=0 ; "i" <' 5  ; "i" :n= "i" +' 1 ) 
        {If ("i" >' "x") 
          Then "ok" :b= bfalse
          Else "sum" :n= "sum" +' "x" 
           End} ).
         


Check ( NAT "x" ;;; 
        BOOL "ok" ;;;
        pointer * "p" ;;;
        int_main() {Bool "b" ::= bfalse ;;
                   cin>> "x" ;;
                  If ("x" %' 2 == 0) 
                  Then "ok" :b= btrue 
                  End  ;;
                  cout<< "ok" } ).

Check ( int_functie "factorial"(( "n" )){ Nat "factorial" ::= 1 ;;
                                          Nat "counter" ::= "n" ;;
                                          While( "counter" >' 1 ){ Nat "factorial" ::= "factorial" *' "counter" ;;  
                                                                   Nat "counter" ::= "counter" -' 1  ;;
                                                                   cout<< "factorial" } } ;;;
                NAT "valoare" ;;;
                int_main() {
                   cin>> "valoare" ;;
                   call "factorial"((("valoare"))) }).     





Inductive Mem :=
  | mem_default : Mem
  | offset : nat -> Mem.

Scheme Equality for Mem.
Definition Env := string -> Mem.

Definition MemLayer := Mem -> ValueTypes.

Definition Stack := list Env.

Inductive Config :=
| config : nat -> Env -> MemLayer -> Stack -> Config.

Definition env : Env := fun x => mem_default.
Compute (env "z").
Definition mem : MemLayer := fun x => err_undeclared.
Definition stack : Stack := [env].

Definition env1 : Env :=
  fun x =>
    if(string_beq "n" x)
    then offset 0
    else if(string_beq "y" x)
            then offset 1
            else if(string_beq "z" x)
                    then offset 2
                    else if (string_beq "w" x)
                         then offset 3
                         else if(string_beq "t" x)
                              then offset 4
                              else if (string_beq "s" x)
                                   then offset 5
                              else mem_default.



Definition check_eq_over_types (t1 : ValueTypes) (t2 : ValueTypes) : bool :=
  match t1 with
    | err_undeclared => match t2 with 
                     | err_undeclared => true
                     | _ => false
                     end
    | default_nat => match t2 with 
                  | default_nat => true
                  | _ => false
                  end
    | default_bool => match t2 with 
                  | default_bool => true
                  | _ => false
                  end
    | default_string => match t2 with 
                  | default_string => true
                  | _ => false
                  end
    | err_assignment => match t2 with 
                  | err_assignment => true
                  | _ => false
                  end
    | natural x => match t2 with
                  | natural x => true
                  | _ => false
                  end
    | res_boolean x => match t2 with 
                  | res_boolean x => true
                  | _ => false
                  end
    | res_stringg x => match t2 with
                  | res_stringg x => true
                  | _ => false
                  end
    | code x => match t2 with
                  | code x => true
                  | _ => false
                 end
    | arr_value x => match t2 with
                  | arr_value x => true
                  | _ => false
                 end
  end.

Compute (check_eq_over_types (err_undeclared) (natural 10)).
Compute (check_eq_over_types (natural 1) (natural 2)).
Compute (check_eq_over_types (res_stringg "a") (res_boolean true)).
Compute (check_eq_over_types (res_stringg "a") (res_stringg "b")).


(*SEMANTICA PENTRU EXPRESIILE ARITMETICE*)

Fixpoint aeval_fun (a : AExp) (env : Env) (mem : MemLayer) : ErrorNat :=
  match a with
 | avar v => match (mem (env v)) with
                | natural n => n
                | _ => error_nat
                end
  | anum v => v
  | aplus a1 a2 => (plus_ErrorNat (aeval_fun a1 env mem) (aeval_fun a2 env mem))
  | amul a1 a2 => (mul_ErrorNat (aeval_fun a1 env mem) (aeval_fun a2 env mem))
  | aminus a1 a2 => (minus_ErrorNat (aeval_fun a1 env mem) (aeval_fun a2 env mem))
  | adiv a1 a2 => (div_ErrorNat  (aeval_fun a1 env mem) (aeval_fun a2 env mem))
  | amodulo a1 a2 => (modulo_ErrorNat (aeval_fun a1 env mem) (aeval_fun a2 env mem))
  end.


Reserved Notation "A // M =[ S ]=> N" (at level 30).
Inductive aeval : AExp -> Env -> MemLayer -> ErrorNat -> Prop :=
| const : forall n sigma m , anum n // m =[ sigma ]=> n 
| var : forall v sigma m ,avar v // m =[ sigma ]=>  match (m (sigma v)) with
                                                     | natural x => x
                                                     | _ => error_nat
                                                      end
| addd : forall a1 a2 i1 i2 sigma n,
    a1 // mem =[ sigma ]=> i1 ->
    a2 // mem =[ sigma ]=> i2 ->
    n = plus_ErrorNat i1 i2 ->
    (a1 +' a2) // mem =[sigma]=> n
| diff: forall a1 a2 i1 i2 sigma n,
    a1 // mem =[ sigma ]=> i1 ->
    a2 // mem =[ sigma ]=> i2 ->
    n = minus_ErrorNat i1 i2 ->
    (a1 -' a2) // mem=[sigma]=> n
| times : forall a1 a2 i1 i2 sigma n,
    a1 // mem =[ sigma ]=> i1 ->
    a2 // mem =[ sigma ]=> i2 ->
    n = mul_ErrorNat i1 i2 ->
    (a1 *' a2) // mem =[sigma]=> n
| divv : forall a1 a2 i1 i2 sigma n,
    a1 // mem=[ sigma ]=> i1 ->
    a2 // mem=[ sigma ]=> i2 ->
    n = div_ErrorNat i1 i2 ->
    (a1 /' a2) // mem =[sigma]=> n
| moduloo : forall a1 a2 i1 i2 sigma n,
    a1 // mem=[ sigma ]=> i1 ->
    a2 // mem=[ sigma ]=> i2 ->
    n = modulo_ErrorNat i1 i2 ->
    (a1 %' a2) // mem=[sigma]=> n
where "a // mem =[ sigma ]=> n" := (aeval a sigma mem n).


Example ex1_addd : (5 +' 3) // mem =[ env ]=> 8.
Proof.
eapply addd.
-apply const.
-apply const.
-simpl.
reflexivity.
Qed.

Example ex2_divv_err : (100 /' 0) // mem =[ env ]=> error_nat.
Proof.
eapply divv.
-apply const.
-apply const.
-simpl.
reflexivity.
Qed.

(*SEMANTICA PENTRU EXPRESIILE BOOLEENE*)

Fixpoint beval_fun (a : BExp) (envnat : Env) (mem : MemLayer) : ErrorBool :=
  match a with
  | btrue => true
  | bfalse => false
  | berror => error_bool
  | bvar v => match mem(env v) with
                | res_boolean n => n
                | _ => error_bool
                end
  | blessthan a1 a2 => (blessthan_ErrorBool (aeval_fun a1 envnat mem) (aeval_fun a2 envnat mem))
  | bgreaterthan a1 a2 => (greaterthan_ErrorBool (aeval_fun a1 envnat mem ) (aeval_fun a2 envnat mem))
  | bnot b1 => (bnot_ErrorBool (beval_fun b1 envnat mem))
  | band b1 b2 => (band_ErrorBool (beval_fun b1 envnat mem) (beval_fun b2 envnat mem))
  | bor b1 b2 => (bor_ErrorBool (beval_fun b1 envnat mem) (beval_fun b2 envnat mem))
  | bequal a1 a2 => (bequal_ErrorBool (aeval_fun a1 envnat mem) (aeval_fun a2 envnat mem))
  end.

 
Reserved Notation "B \\ M ={ S }=> B'" (at level 70).

Inductive beval : BExp -> Env -> ErrorBool -> MemLayer -> Prop :=
| b_error: forall sigma m, berror \\ m ={ sigma }=> error_bool
| b_true : forall sigma m, btrue \\ m ={ sigma }=> true
| b_false : forall sigma m, bfalse  \\ m ={ sigma }=>   false
| b_var : forall v sigma m, bvar v  \\ m ={ sigma }=>   match m(sigma v) with
                                                | res_boolean x => x
                                                | _ => error_bool
                                                end
| b_lessthan : forall a1 a2 i1 i2 sigma b m,
    a1 // m =[ sigma ]=> i1 ->
    a2 // m =[ sigma ]=> i2 ->
    b = (blessthan_ErrorBool i1 i2) ->
    (a1 <' a2)  \\ m ={ sigma }=> b
| b_greaterthan : forall a1 a2 i1 i2 sigma b m,
    a1 // m =[ sigma ]=> i1 ->
    a2 // m =[ sigma ]=> i2 ->
    b = (greaterthan_ErrorBool i1 i2) ->
    (a1 >' a2)  \\ m ={ sigma }=> b
| b_not : forall a1 i1 sigma b m,
    a1 \\ m ={ sigma }=> i1 ->
    b = (bnot_ErrorBool i1) ->
    (!a1)  \\ m ={ sigma }=> b 
| b_and : forall a1 a2 i1 i2 sigma b m,
    a1  \\ m ={ sigma }=> i1 ->
    a2  \\ m ={ sigma }=> i2 ->
    b = (band_ErrorBool i1 i2) ->
    (a1 and' a2)  \\ m ={ sigma }=> b
| b_or : forall a1 a2 i1 i2 sigma b m,
    a1 \\ m ={ sigma }=> i1 ->
    a2 \\ m ={ sigma }=> i2 ->
    b = (bor_ErrorBool i1 i2) ->
    (a1 or' a2)  \\ m ={ sigma }=> b 
| b_equal: forall a1 a2 i1 i2 sigma b m,
    a1 // m =[ sigma ]=> i1 ->
    a2 // m =[ sigma ]=> i2 ->
    b = bequal_ErrorBool i1 i2 ->
    (a1 == a2) \\ m ={ sigma }=> b
where "B \\ M ={ S }=> B'" := (beval B S B' M).

Example ex3_and : (btrue and' bfalse) \\ mem={ env }=> false.
Proof.
eapply b_and.
-apply b_true.
-apply b_false.
-simpl.
reflexivity.
Qed.

Example ex4_lt : (3 <' 7) \\ mem={ env }=> true.
Proof.
eapply b_lessthan.
-apply const.
-apply const.
-simpl.
reflexivity.
Qed.

(*SEMANTICA PENTRU OPERATIILE PE STRINGURI*)

(*Fixpoint seval_fun (s : Strings) (env : Env)(mem : MemLayer) : ErrorString :=
  match s with
  | string_var s1 => match (mem(env s1)) with
              | res_stringg a => a
              | _ => error_string
               end
  | string_str s1 => s1
  | strcat s1 s2 => (concat_string (str_eval_fun s1 env mem) (str_eval_fun s2 env mem)) 
  | strcmp s1 s2 => (strcmp_string (str_eval_fun s1 env mem) (str_eval_fun s2 env mem))
end.
*)


Reserved Notation "S \*/ M ={ N }=> B" (at level 60).
Inductive seval : Strings -> Env -> MemLayer -> ErrorString -> Prop :=
| s_const : forall s sigma m, string_str s \*/ m={ sigma }=> s
| s_var : forall s sigma m, string_var s \*/ m ={ sigma }=> match (m(env s)) with
                                                             | res_stringg a => a
                                                             | _ => error_string
                                                              end
| s_concat : forall s1 s2 sigma s i1 i2 m,
    s1 \*/ m={ sigma }=> i1 ->
    s2 \*/ m={ sigma }=> i2 ->
    s = concat_string i1 i2 ->
    (i1 +/ i2) \*/ m ={ sigma }=> s
| s_strcmp : forall s1 s2 sigma s i1 i2 m,
    s1 \*/ m={ sigma }=> i1 ->
    s2 \*/ m={ sigma }=> i2 ->
    s = strcmp_string i1 i2 ->
    (i1 ? i2) \*/ m ={ sigma }=> s
where "S \*/ M ={ N }=> B" := (seval S N M B).

Example ex5_strcat : strcat ("proiect" )("plp") \*/ mem={ env }=> "proiectplp".
Proof.
eapply s_concat.
-apply s_const.
-apply s_const.
-simpl.
reflexivity.
Qed.

Compute string_length "georgiana".

Example ex6_strcmp : strcmp ("abcd")("abc") \*/ mem={ env }=> "abcd".
Proof.
eapply s_strcmp.
-apply s_const.
-apply s_const.
-simpl.
reflexivity.
Qed.


(*SEMANTICA PENTRU VECTORI*)

Definition element (v : ErrorArray) (n : nat) : ValueTypes :=
match v with
| nat_array s n l => natural (List.nth n l 0)  
| bool_array s n l => res_boolean (List.nth n l false) 
| string_array s n l => res_stringg (List.nth n l "") 
| error_array => err_undeclared
end.

Definition last_element (v : ErrorArray) : ValueTypes :=
match v with 
| nat_array s n l => natural (List.last l 0)
| bool_array s n l => res_boolean (List.last l false)
| string_array s n l => res_stringg (List.last l "")
| error_array => err_undeclared
end.

Definition delete_element (v : ErrorArray) (nr : nat) : ValueTypes :=
match v with
| nat_array s n l => arr_value(nat_array s n (List.remove eq_nat_dec (List.nth nr l 0) l))
| bool_array s n l => arr_value(bool_array s n (List.remove bool_dec (List.nth nr l false) l))
| string_array s n l =>arr_value(string_array s n (List.remove string_dec (List.nth nr l "") l))
| error_array => err_undeclared
end.

Compute delete_element ("v"[[ 10 ]] n:= [ 1 , 2 , 3 ]) 0.

Definition insert_nat (v : ErrorArray) (nr : nat) : ValueTypes:=
match v with
| nat_array s n l => arr_value (nat_array s n (l++[nr]))
| bool_array s n l => arr_value v
| string_array s n l => arr_value v
| error_array => err_undeclared
end.

Compute insert_nat ("v"[[ 10 ]] n:= [ 1 , 2 , 3 ]) 4.

Inductive array_eval : Array_op -> Env -> MemLayer -> ValueTypes -> Prop :=
| arr_constt: forall arr sigma m, array_eval (arr_const arr) sigma m (arr_value arr)
| arr_varr: forall arr sigma m, array_eval (arr_var arr) sigma m  (m(sigma arr))
| arr_last: forall arr sigma m, array_eval (last_array arr) sigma m (last_element arr) 
| arr_delete_elem: forall arr nr sigma m, array_eval (delete_elem arr nr) sigma m (delete_element arr nr)
| arr_add_elem_nat: forall arr nr sigma m, array_eval (add_elem_nat arr nr) sigma m (insert_nat arr nr)
.

Example ex7_last_elem_of_arr : array_eval (last_array ("v"[[ 10 ]] n:= [ 1 , 2 , 3 ])) env mem (natural 3) .
Proof.
apply arr_last.
Qed.

Example ex8_delete_from_arr : array_eval (delete_elem ("v"[[ 10 ]] n:= [ 1 , 2 , 3 ]) 1) env mem (arr_value("v"[[ 10 ]] n:= [ 1  , 3 ])).
Proof.
apply arr_delete_elem.
Qed.


Example ex8_insert_to_arr : array_eval (add_elem_nat ("v"[[ 10 ]] n:= [ 1 , 2 , 3 ]) 4) env mem (arr_value("v"[[ 10 ]] n:= [ 1 , 2 , 3 , 4 ])).
Proof.
apply arr_add_elem_nat.
Qed.





(*Definition update (env : Env) (x : string) (v : ValueTypes) : Env :=
 fun y =>
  if (string_beq y x) 
   then
     if(andb (check_eq_over_types err_undeclared (env y)) (negb (check_eq_over_types default_nat v)))
       then err_undeclared
       else 
           if (andb (check_eq_over_types err_undeclared (env y)) (negb (check_eq_over_types default_bool v)))
           then err_undeclared
           else 
              if(andb (check_eq_over_types err_undeclared (env y)) (negb (check_eq_over_types default_string v)))
              then err_undeclared
       else 
           if (andb (check_eq_over_types err_undeclared (env y)) ((check_eq_over_types default_nat v)))
           then default_nat
           else 
             if (andb (check_eq_over_types err_undeclared (env y)) ((check_eq_over_types default_bool v))) 
             then default_bool
             else
                if (andb (check_eq_over_types err_undeclared (env y)) ((check_eq_over_types default_string v)))
                then default_string
        else 
           if(orb (check_eq_over_types default_nat (env y)) (check_eq_over_types v (env y)))
           then v
           else 
              if(orb (check_eq_over_types default_bool (env y)) (check_eq_over_types v (env y)))
              then v
              else
                 if(orb (check_eq_over_types default_string (env y)) (check_eq_over_types v (env y)))
                 then v
                 else err_assignment

  else (env y).

Compute (env "y").
Compute (update (update env "y" (default_bool)) "y" (res_boolean true) "y").
Compute ((update (update (update env "y" default_string) "y" (natural 10)) "y" (res_boolean true)) "y").

Notation "S [ V // X ]" := (update S X V) (at level 0).
*)


(*Definition update_env (env: ENV) (x: string) (n: Mem) : ENV :=
  fun y =>
      (* If the variable has assigned a default mory zone, 
         then it will be updated with the current memory offset *)
      if (andb (string_beq x y ) (Mem_beq (env y) mem_default))
      then
       n
      else
        (env y).

Definition env1 : ENV := fun x => mem_default.
(* Initially each variable is assigned to a default memory zone *)
Compute (env "z"). (* The variable is not yet declared *)

(* Example of updating the environment, based on a specific memory offset *)
Compute (update_env env1 "x" (offset 9)) "x".

(* Function for updating the memory layer *)
(*Definition update_mem (mem : MemLayer) (env : ENV) (x : string) (type : Mem) (v : ValueTypes) : MemLayer :=
  fun y => 
      if(andb (Mem_beq (env x) type) (Mem_beq y type))
      then
        if(andb(check_eq_over_types err_undeclared (mem y)) (negb(check_eq_over_types default_nat v)))
        then err_undeclared
        else if (check_eq_over_types err_undeclared (mem y))
            then default_nat
            else if(orb(check_eq_over_types default_nat (mem y)) (check_eq_over_types v (mem y)))
                 then v
                 else err_assignment
      else (mem y).*)

(* Each variable/function name is initially mapped to undeclared *)
Definition mem : MemLayer := fun x => err_undeclared.*)















