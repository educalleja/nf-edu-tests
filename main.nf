#!/usr/bin/env nextflow 
params.timeout = 10
params.exit = 0
params.times = 2
params.forks = 0

process foo {
  maxForks params.forks
  input: val(x)
  output:
    path 'output.txt'
    
  script:
  """
  echo "Hello, iteration $x (timeout $params.timeout)" >> output.txt
  sleep $params.timeout
  exit $params.exit
  """


}

process bar {
  script:
  """
  echo "This task fails on purpose"
  exit 1
  """
}

process pre {
  script:
  """
  exit 0
  """
}

workflow {
  main:
  pre()
  channel.of(1..params.times) | foo
  bar()

  publish:
    first_output = foo.out
}

output {
    first_output {
        path '.'
    }
}