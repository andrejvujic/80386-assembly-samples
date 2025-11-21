# Intel 80386 Assembly samples (AT&T syntax)

This repository contains code examples for Intel 80836 Assembly written in AT&T syntax.

# How to run?

These samples were written on x86_64 Ubuntu. To compile them you will need to install `gcc-multilib`. You can install it using:

```
sudo apt-get install -y gcc-multilib
```

To compile the code use `gcc` with the `-m32` flag:

```
gcc -m32 example.S
```

And finally run it:

```
./a.out
```

# x86 system calls

You can view all x86 system calls <a href="https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#x86-32_bit">here</a>.