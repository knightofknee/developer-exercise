require 'minitest/autorun'

class Array
  def where(searchObject)
    results = []

    self.each {|entry|
      specsMet = 0
      searchObject.each {|key, value|
        if value.is_a?(String)
          if entry[key].include? value
            specsMet += 1
          end
        end
        if value.is_a?(Integer)
          if entry[key] == value
            specsMet += 1
          end
        end
        if value.is_a?(Regexp)
          if entry[key].match(value)
            specsMet += 1
          end
        end
      }
      if specsMet == searchObject.size
        results.push(entry)
      end
    }

    # searchObject.each {|key, value|
    #   if value.is_a?(String)
    #     self.each{|entry|
    #       if entry[key].include? value
    #         results.push(entry)
    #       end
    #     }
    #   end
    #   if value.is_a?(Integer)
    #     self.each{|entry|
    #       if entry[key] == value
    #         results.push(entry)
    #       end
    #     }
    #   end
    #   if value.is_a?(Regexp)
    #     # dividedVals = value.split('/')
    #     # match = true
    #     puts 'hi'
    #     self.each{|entry|
    #       if entry[key].match(value)
    #         results.push(entry)
    #       end
    #     }
        # dividedVals.each{|val|
        #   self.each{|entry|
        #     puts "regex #{val}"
        #     if !entry[key].includes(val)
        #       match = false
        #     end
        #   }
        #   if match
        #     results.push(entry)
        #   end
        # }
    #
    #   end
    # }
    puts "currently #{results.map{|x| x}}"
    results
  end
end

class WhereTest < Minitest::Test
  def setup
    @boris   = {:name => 'Boris The Blade', :quote => "Heavy is good. Heavy is reliable. If it doesn't work you can always hit them.", :title => 'Snatch', :rank => 4}
    @charles = {:name => 'Charles De Mar', :quote => 'Go that way, really fast. If something gets in your way, turn.', :title => 'Better Off Dead', :rank => 3}
    @wolf    = {:name => 'The Wolf', :quote => 'I think fast, I talk fast and I need you guys to act fast if you wanna get out of this', :title => 'Pulp Fiction', :rank => 4}
    @glen    = {:name => 'Glengarry Glen Ross', :quote => "Put. That coffee. Down. Coffee is for closers only.",  :title => "Blake", :rank => 5}

    @fixtures = [@boris, @charles, @wolf, @glen]
  end

  def test_where_with_exact_match
    assert_equal [@wolf], @fixtures.where(:name => 'The Wolf')
  end

  def test_where_with_partial_match
    assert_equal [@charles, @glen], @fixtures.where(:title => /^B.*/)
  end

  def test_where_with_mutliple_exact_results
    assert_equal [@boris, @wolf], @fixtures.where(:rank => 4)
  end

  def test_with_with_multiple_criteria
    assert_equal [@wolf], @fixtures.where(:rank => 4, :quote => /get/)
  end

  def test_with_chain_calls
    assert_equal [@charles], @fixtures.where(:quote => /if/i).where(:rank => 3)
  end
end

