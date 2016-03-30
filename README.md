# environments

Ensure Xcode and Command Line Utilities are installed.

Setup the main dotfiles and configurations

```
./setup.sh
```

To use a case-sensitive drive instead of the default on OSX you can create a sparse bundle that auto expands.

```
./workspace.sh create
./workspace.sh mount
./workspace.sh automount
```

The script will make a new folder/mapped drive called ~/GitHub.
