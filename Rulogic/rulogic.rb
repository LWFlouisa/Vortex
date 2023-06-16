# assertion = empty body ex. cat(tom).
# rule      = [:head, :body]

# head      = [ :noun( ]
# body      = [ adjective, verb, adverb, ). ]

require "parlset"

module Rulogic
  class RulogicParser < Parslet::Parser
    root(:predicate)

    rule(:predicate) { assertion | rule | query }

    ## Basics
    rule(:lbracket) { str("(") }
    rule(:rbracket) { str(")") }
    rule(:comma)    { str(",") }
    rule(:punc)     { str(".") }
    rule(:space)    { str(" ") }

    ## Query syntax
    rule(:request)  {        str("?") }
    rule(:present)  { str("present?") }
    rule(:lenclose) {        str("[") }
    rule(:renclose) {        str("]") }

    ## Names
    rule(:name) { pepper | luna }

    rule(:pepper) { str("pepper") }
    rule(:luna)   {   str("luna") }

    ### Nouns
    rule(:noun) { cat | dog }

    rule(:cat) { str("cat") }
    rule(:dog) { str("dog") }

    ### Adjectives
    rule(:adjective) { black | white }

    rule(:black) { str("black") }
    rule(:white) { str("white") }

    ### Verbs
    rule(:verb) { barks | meows }

    rule(:barks) { str("barks") }
    rule(:meows) { str("meows") }

    ### Specific syntax
    rule(:assertion) { noun     >>
                       lbracket >>
                       name     >>
                       rbracket >>
                       punc
    }

    rule(:rule)      { noun      >>
                       lbracket  >>
                       adjective >>
                       comma     >>
                       space     >>
                       verb      >>
                       rbracket  >>
                       punc
    }

    rule(:query) { question >>
                   space    >>
                   lenclose >> noun >> renclose >>
                   present
    }
  end

  class RulogicTransform << Parslet::Transform
    # Basics
    rule(:lbracket) { "(" }
    rule(:rbracket) { ")" }
    rule(:comma)    { "," }
    rule(:punc)     { "." }
    rule(:space)    { " " }

    ## Query syntax
    rule(:request)  {        "?" }
    rule(:present)  { "present?" }
    rule(:lenclose) {        "[" }
    rule(:renclose) {        "]" }

    ## Names
    rule(:pepper) { "pepper" }
    rule(:luna)   {   "luna" }

    ### Nouns
    rule(:cat) { "cat" }
    rule(:dog) { "dog" }

    ### Adjectives
    rule(:black) { "black" }
    rule(:white) { "white" }

    ### Verbs
    rule(:barks) { "barks" }
    rule(:meows) { "meows" }
  end

  class RulogicInput
    def self.interpreter
      begin
        print "Ahusacos() >> "; input = gets.chomp # .split(" ")

        parser      = AhusacosParser.new
        transform   = AhusacosTransform.new

        tree        = parser.parse(input)
        ast         = transform.apply(tree)
        ast_output = "#{ast}".to_s

        puts "Your Result: #{ast_output}"

        # system("espeak -p 95 '#{ast_output}'")

        # SmartSearch::SearchQuery.convert_query
        # SmartSearch::SearchQuery.is_present?
      rescue Parslet::ParseFailed => error
        puts error.parse_failure_cause.ascii_tree
      end
    end
  end
end
