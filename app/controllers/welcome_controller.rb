class WelcomeController < ApplicationController
  def index
    query = params[:query] || ""
    @news = New.search(query).response["aggregations"]["news"]["buckets"]
    @day_news = New.search_contributors(query).response["aggregations"]
    @contributors = @day_news['uniq_contributors']['buckets'].sort_by{ |con| con['key'] }.map { |cont| cont['key']}
    @contributors_pie = @day_news['uniq_contributors']['buckets'].map{ |cont| [cont['key'], cont['doc_count']]}

    @values = []
    @original = []
    @values.push(['Country', 'Popularity'])

    @regions = [
      [{v:"005", f:"South America"}, 1],
      [{v:"011", f:"Western Africa"}, 1],
      [{v:"013", f:"Central America"}, 1],
      [{v:"014", f:"Eastern Africa"}, 1],
      [{v:"015", f:"Northern Africa"}, 1],
      [{v:"017", f:"Middle Africa"}, 1],
      [{v:"018", f:"Southern Africa"}, 1],
      [{v:"029", f:"Caribbean"}, 1],
      [{v:"030", f:"Eastern Asia"}, 1],
      [{v:"034", f:"Southern Asia"}, 1],
      [{v:"035", f:"South-Eastern Asia"}, 1],
      [{v:"039", f:"Southern Europe"}, 1],
      [{v:"053", f:"Australia and New Zealand"}, 1],
      [{v:"054", f:"Melanesia"}, 1],
      [{v:"057", f:"Micronesia"}, 1],
      [{v:"061", f:"Polynesia"}, 1],
      [{v:"143", f:"Central Asia"}, 1],
      [{v:"145", f:"Western Asia"}, 1],
      [{v:"151", f:"Eastern Europe"}, 1],
      [{v:"154", f:"Northern Europe"}, 1],
      [{v:"155", f:"Western Europe"}, 1],
      [{v:"021", f:"Northern America"}, 1]
    ]


    @news.each do |new|
      unless new.to_a[0][1] === ""
        if new.to_a[0][1] === "North America"
          @values.push(["Northern America", new.to_a[1][1]])
          @original.push([new.to_a[0][1], new.to_a[1][1]])
          tmp = @regions.map { |a| (a[1] = new.to_a[1][1]) if a[0][:f] == 'Northern America' }

        elsif new.to_a[0][1] === "Asia Pacific"
          @original.push([new.to_a[0][1], new.to_a[1][1]])
          @values.push(["Eastern Asia", new.to_a[1][1]])
          tmp = @regions.map { |a| (a[1] = new.to_a[1][1]) if a[0][:f] == 'Eastern Asia' }

        elsif new.to_a[0][1] === "Europe"
          @original.push([new.to_a[0][1], new.to_a[1][1]])

          @values.push(["Northern Europe", new.to_a[1][1]])
          @values.push(["Western Europe", new.to_a[1][1]])
          @values.push(["Eastern Europe", new.to_a[1][1]])
          @values.push(["Southern Europe", new.to_a[1][1]])
          tmp = @regions.map { |a| (a[1] = new.to_a[1][1]) if a[0][:f] == 'Northern Europe' }
          tmp = @regions.map { |a| (a[1] = new.to_a[1][1]) if a[0][:f] == 'Western Europe' }
          tmp = @regions.map { |a| (a[1] = new.to_a[1][1]) if a[0][:f] == 'Eastern Europe' }
          tmp = @regions.map { |a| (a[1] = new.to_a[1][1]) if a[0][:f] == 'Southern Europe' }

        else
          @values.push([new.to_a[0][1], new.to_a[1][1]])
          @original.push([new.to_a[0][1], new.to_a[1][1]])
        end
      end
    end

    @regions = @regions.map { |obj| obj if (@values.flatten.include? obj[0][:f]) }.compact

    gon.countries = @values
    gon.regions = @regions

    @array = []

    @day_news['publications_days']['buckets'].each do |day|
      day['contributors']['buckets'].sort_by!{ |con| con['key'] }
      data = []
      data.push(day['key_as_string'])
      p 'daaaaaaaaay'
      p day['contributors']['buckets']
      p 'daaaaaaaaay'

      p 'asdasdasdadas'
      p @contributors
      p 'asdasdasdadas'

      valores = @contributors.map { |n| day['contributors']['buckets'].as_json.select{|co| co["key"] == n}.first ? day['contributors']['buckets'].as_json.select{|co| co["key"] == n}.first['doc_count'] : 0 }
      # valores = @contributors.map do |contributor|
      #   val = day['contributors']['buckets'].as_json.select{|co| co["key"] == contributor}.first
      #   p '--------------'
      #   p val
      #   p '--------------'

      #   unless val.nil?
      #     val['doc_count']
      #   else
      #     return 0
      #   end
      # end
      

      valores.prepend(day['key_as_string'])
      valores.append('')
      p 'valores'
      p valores 
      p 'valores'
      
      @array.push(valores)
    end
    @contributors.prepend('Contributors')
    @contributors.append({ role: 'annotation' })

    @array.prepend(@contributors)
    p 'arrraaaaaay'
    p @array

    gon.contributors = @array
    gon.contributors_pie = @contributors_pie
  end
end
