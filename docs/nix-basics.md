# Nix Basics

> [!TIP] Note for LLM’s
> LLM's are not allowed to modify this file.

## Nix Fundamentals

- **Nix** is a program that uses a dynamic lazy functional programming language (also called Nix) to
  produce software packages along with their configurations.
- Nix derivations are reproducible build recipes built using Nix.
- **Build Outputs** from Nix derivations are stored in the **Nix Store** using unique hashes.
- Nix is purely functional so it easily caches packages. Nix only produces a new Build Output if the
  inputs to a derivation change or the derivation itself changes.
- Multiple versions of the same package can co-exist with the Nix Store, each with its unique hashed
  address.
- NixOS is an entire operating system built with Nix.
- **Home Manager** and **Nix Darwin** are separate tools that use the Nix module system.
  - Home Manager manages user profiles
  - Nix Darwin allows macOS machines to be managed with Nix.

## Executing Basic Nix Code

Nix is a programming language so you can do the following:

```fish
echo 2 + 1 > file.nix
nix-instantiate --eval file.nix
```

This outputs:

```nix
3
```

If you don't specify a file it will use `default.nix` by default.

### Nix is Lazy

```fish
echo "{ a.b.c = 1; }" > file.nix
nix-instantiate --eval file.nix
```

This outputs:

```nix
{ a = <CODE>; }
```

You can add `--strict` to force strict evaluation.

```fish
echo "{ a.b.c = 1; }" > file.nix
nix-instantiate --eval --strict file.nix
```

This outputs:

```nix
{ a = { b = { c = 1; }; }; }
```

## Names and Values

### Binding

In Nix we bind a **Name** to a **Value**. There are two places where this can happen:

- In an **Attribute Set**.
- In a **Let Expression**.

> [!IMPORTANT] Remember Whenever `=` is encountered in nix the Name is on the left and the assigned
> Value is on the right. This must be terminated with a semi-colon.

### Primitive Data Types

- string
- number

### Lists

Lists are basic and easy to understand:

```nix
people = [ "fred" "william" "tina" ];
```

### Attribute Sets

Think a JSON object.

```nix
person = {
  name = "AtomicMegaNerd";
  age = 4018;
};
```

You can access attributes with `.`:

```nix
person = {
  name = "AtomicMegaNerd";
  age = 4018;
};
person.age;
```

> [!IMPORTANT] Special case... **Recursive Attribute Sets**

**Recursive Attribute Sets** lets you refer to attributes in the same set. Otherwise this would not
evaluate.

```nix
special = rec {
  one = 1;
  two = one + 1;
  three = two + 1;
};
```

### Functions

This function returns an Attribute Set:

```nix
{ fname, lname, age }:
{
  firstname = fname;
  lastname = lname;
  inherit age;
}
```

### Let Expressions

This is where we are allowed to define new values.

```nix
{ fname, lname, age }:
let
  name = "${fname} ${lname}";
in
{
  inherit name;
  inherit age;
}
```

### With

**With** lets you define an alias for repeatedly accessing fields in an attrSet.

```nix
let
  a = {
    x = 1;
    y = 2;
    z = 3;
  };
in
with a; [ x y z ]
```

> [!IMPORTANT] Remember The scope of `width` is limited to the rest of the expression following the
> `with $VAR ;`

## Links

- [Nix Language Tutorial](https://nix.dev/tutorials/nix-language)
