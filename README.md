# Coconductor

[![Build Status](https://travis-ci.org/benbalter/coconductor.svg?branch=master)](https://travis-ci.org/benbalter/coconductor)

A Code of Conduct detector based off [Licensee](https://github.com/benbalter/licensee).

## Installation

`gem install coconductor` or add `gem 'coconductor'` to your project's Gemfile and `bundle install`

## Usage

### Ruby

```ruby
path = 'path/to/some/project'
code_of_conduct = Coconductor.code_of_conduct(path)

code_of_conduct.key
=> "contributor-covenant/version/1/4"

code_of_conduct.family
=> "contributor-covenant"

code_of_conduct.version
=> 1.4

# lower-level access

project = Coconductor.project(path)

project.code_of_conduct.key
=> "contributor-covenant/version/1/4"

project.code_of_conduct_file.filename
=> "CODE_OF_CONDUCT.txt"

project.code_of_conduct_file.matcher
=> Coconductor::Matchers::Dice

project.code_of_conduct_file.confidence
=> 98.9648033126294
```

### Command line

`$ bin/coconductor PATH`

#### Example output

```
Key: contributor-covenant/version/1/4
Family: contributor-covenant
Version: 1.4
Filename: CODE_OF_CONDUCT.md
Confidence: 98.9648033126294
Matcher: Coconductor::Matchers::Dice
```

### Codes of Conduct detected

* Contributor Covenant (all official languages and versions)
* Citizen Code of Conduct (all versions)
