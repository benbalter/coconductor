# Coconductor

[![Build Status](https://travis-ci.org/benbalter/coconductor.svg?branch=master)](https://travis-ci.org/benbalter/coconductor) [![Gem Version](https://badge.fury.io/rb/coconductor.svg)](http://badge.fury.io/rb/coconductor)

A (work-in-progress) Code of Conduct detector based off [Licensee](https://github.com/benbalter/licensee).

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

```
Coconductor commands:
  coconductor detect [PATH]   # Detect the code of conduct of the given project
  coconductor diff [PATH]     # Compare the given code of conduct text to a known code of conduct
  coconductor help [COMMAND]  # Describe available commands or one specific command
  coconductor version         # Return the Coconductor version

Options:
  [--remote], [--no-remote]  # Assume PATH is a GitHub owner/repo path
```

#### Example output

```
Code of conduct:  Contributor Covenant v1.4
Key:              contributor-covenant/version/1/4
Family:           contributor-covenant
Version:          1.4
Path:             docs/CODE_OF_CONDUCT.md
Confidence:       98.96%
Matcher:          Coconductor::Matchers::Dice
Content hash:     627827ddda36b5c42b3a00418d3d7d5b16e5088a
```

### Codes of Conduct detected

* Contributor Covenant (all official languages and versions)
* Citizen Code of Conduct (all versions)
* The No Code of Conduct (latest version)
* Geek Feminism Code of Conduct (latest long and short form versions)

### Matching strategy

* Exact match (after normalization)
* Field aware exact match (e.g., ignoring fields intended to be filled in)
* [Sørensen–Dice coefficient](https://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient)
