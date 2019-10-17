## Contributing

Check [open issues](https://github.com/bbulpett/zebra-zpl/issues) for things that need work.  
Also check any [open pull requests](https://github.com/bbulpett/zebra-zpl/pulls) to make sure any changes you want to make haven't already been made by someone else.

### Fork & clone the repository

```
git clone git@github.com:<your-username>/zebra-zpl.git
cd zebra-zpl
git remote add upstream git@github.com:bbulpett/zebra-zpl.git
bundle install
```

Then check out a working branch:

```
git checkout -b <my-working-branch>
```

### Write tests

This project uses `rspec`. After writing your tests, you can run tests with the following command:

`bundle exec rspec`


### Write code

Write your code to make your tests pass.

### Update the CHANGELOG with a description and your name

Update `CHANGELOG.md` with the description of your code changes and your name on the line after `"* Your contribution here"`.

### Commit & Push your changes

Commit and push your changes to your working branch.

```
git commit -am 'Add some feature'
git push origin <my-working-branch>
```

### Open a pull request

Open a pull request against upstream master and your working branch. Give a brief description of what your PR does and explain what the code changes do.

Thank you!
