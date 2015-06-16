# .files

This repository contains my dotfiles, or at least all the bits that
aren't sensitive.  The eventual goal is a consistent configuration
wherever I am.

## Dependencies

GNU stow is used to distribute the dotfiles.  Once stow is installed,
simply clone the repository, change to its top directory, and stow
whichever package is needed:

```bash
$ git clone git://github.com/mathuin/.files.git
$ cd .files
$ stow bash
```

## License

These files are released under the MIT License as per the LICENSE file.

