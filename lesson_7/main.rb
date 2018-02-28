require_relative 'train'
require_relative 'route'
require_relative 'station'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

class Main
  attr_reader :trains, :routes, :stations

  def initialize
    @trains = []
    @routes = []
    @stations = []
  end

  def options
    command = nil
    while command != '0'
      show_main_menu
      command = gets.chomp
      case command
        when '1' then manage_stations
        when '2' then manage_trains
        when '3' then manage_routes
        when '4' then list_program_data
        when '0' then nil
        else
          puts "Command #{command} is incorrect!"
      end
    end
  end

  private

  def display_stations_menu
    puts '    Available options:
     1. create station
     0. Return to main menu'
    puts 'Enter the command number:'
  end

  def manage_stations
    display_stations_menu
    command = gets.chomp
    case command
      when '1' then create_station
      when '0' then nil
      else
        puts "incorrect command #{command} for stations management"
    end
  end

  def create_station
    station = create_station!
    return unless station

    stations << station
    puts "You created the station: '#{station.name}'"
    station
  end

  def create_station!
    puts 'Enter the station name: '
    name = gets.chomp
    Station.new(name)
  rescue RuntimeError => e
    puts e.message
    nil
  end

  def display_trains_menu
    puts '    Available options:
     1. create train
     2. set train on route
     3. move train
     4. manage train wagons
     0. Return to main menu'
    puts 'Enter the command number:'
  end

  def manage_trains
    display_trains_menu
    command = gets.chomp
    case command
      when '1' then create_train
      when '2' then set_train_on_route
      when '3' then move_train
      when '4' then manage_train_wagons
      when '0' then nil
      else
        puts "incorrect command #{command} for train management"
    end
  end

  def create_train
    train = create_train!
    if train
      trains << train
      puts "You created train: '#{train.type}' № '#{train.number}'"
      train
    end
  end

  def create_train!
    type = get_train_type
    puts 'Enter train number:'
    number = gets.chomp
    if type == 'p'
      PassengerTrain.new(number)
    elsif type == 'c'
      CargoTrain.new(number)
    end
  rescue RuntimeError => e
    puts e.message
    nil
  end

  def set_train_on_route
    train = select_train
    return unless train

    route = select_route
    train.route = route if route
  end

  def move_train
    train = select_train
    return unless train

    if train.route
      move_train!(train)
    else
      puts 'Train is not on the route'
    end
  end

  def move_train!(train)
    puts "type: 'f' to move forward, 'b' to move backward"
    answer = gets.chomp
    case answer
      when 'f' then train.go_forward
      when 'b' then train.go_back
      else
        puts "incorrect command: #{command}"
    end
  end

  def get_train_type
    puts 'Type type of train:'
    puts "'p' for passenger train, 'c' for cargo train"
    train_type = gets.chomp
    while type != 'p' && type != 'c'
      puts 'You have chosen a nonexistent type! Please, select correct type:'
      train_type = gets.chomp
    end
    train_type
  end

  def select_train
    if trains.empty?
      puts 'no trains'
    else
      number = get_train_number
      train = trains.find { |train| train.number == number }
      return train if train
      puts "no train with number #{number}"
    end
  end

  def get_train_number
    puts 'available trains:'
    trains.each { |train| puts "'#{train.type}' № '#{train.number}'" }
    puts 'Select train number:'
    gets.chomp
  end

  def display_wagons_menu
    puts '    available options:
     1. add wagon
     2. remove wagon
     3. use wagon
     ===============================

     Enter the command number:'
  end

  def manage_train_wagons
    train = select_train
    return unless train
    display_wagons_menu
    command = gets.chomp
    case command
    when '1' then add_wagon(train)
    when '2' then remove_wagon(train)
    when '3' then use_wagon(train)
    else
      puts "incorrect command: #{command}"
    end
  end

  def add_wagon(train)
    wagon = if train.type == 'passenger'
              PassengerWagon.new(rand(50))
            else
              CargoWagon.new(rand(100))
            end
    train.add_wagon(wagon)
    puts "Wagon added to #{train.type} train #{train.number}"
  end

  def remove_wagon(train)
    wagon = select_wagon(train)
    train.remove_wagon(wagon)
    puts 'You removed wagon'
  end

  def use_wagon(train)
    wagon = select_wagon(train)
    case wagon.type
      when 'passenger'
        use_place(wagon)
      when 'cargo'
        use_place(wagon)
    end
  end

  def use_place(wagon)
    puts 'How much space do you want to use? Type the number you want:'
    amount = if wagon.type == 'passenger'
               gets.chomp
             else
               gets.chomp.to_f
             end
    wagon.use_place(amount)
  end

  def select_wagon(train)
    if train.wagons.empty?
      puts "You have no wagons in train: '#{train.type}' № '#{train.number}'"
    else
      train.wagons.each { |wagon| puts "wagon № '#{wagon.number}'" }
      puts 'Select wagon by number:'
      number = gets.chomp.to_i
      wagon = train.wagons.find { |w| w.number == number }
      puts "No wagon with number #{number}" unless wagon
      wagon
    end
  end

  def display_routes_menu
    puts '    Available options:
     ====================================
     1. Create a route
     2. Add the station to the route
     3. Remove the station from the route
     ====================================
     0. Return to main menu
     ===================================='
    puts 'Enter the command number:'
  end

  def manage_routes
    display_routes_menu
    route_option = gets.chomp
    case route_option
      when '1' then create_route
      when '2' then add_station_to_route
      when '3' then remove_station_from_route
      when '0' then nil
      else
        puts "Command #{route_option} is incorrect!"
    end
  end

  def create_route
    if stations.count < 2
      puts "You need at least 2 stations to create route. You already have #{stations.count}"
    else
      route = create_route!
      return unless route

      routes << route
      route
    end
  end

  def create_route!
    puts 'Select first station of the route'
    first = select_station
    puts 'Select last station of the route'
    last = select_station
    Route.new(first, last)
  rescue RuntimeError => e
    puts e.message
    nil
  end

  def add_station_to_route
    route = select_route
    return unless route
    puts 'Select station to add to the route'
    route.add_station(select_station)
  end

  def remove_station_from_route
    route = select_route
    return unless route
    station = select_station(route.stations)
    route.remove_station(station)
  end

  def select_route
    if routes.empty?
      puts 'You have not route!'
    else
      number = get_route_number
      route = routes[number]
      if route
        route
      else
        puts "No route with number '#{number}'"
      end
    end
  end

  def get_route_number
    puts 'Available routes:'
    routes.each_with_index do |route, index|
      puts "#{index} - #{route.to_s}"
    end
    puts 'Type route number:'
    gets.chomp.to_i
  end

  def select_station(stations_to_select_from = nil)
    stations_to_select_from ||= stations
    if stations_to_select_from.empty?
      puts 'You have no stations!'
    else
      puts 'Available stations:'
      stations_to_select_from.each { |station| puts station.name }
      puts 'Type station name:'
      name = gets.chomp
      stations_to_select_from.find { |station| station.name == name }
    end
  end

  #############################################################################

  def list_program_data
    puts '========================================================'
    stations.each do |station|
      station.yield_trains do |train|
        puts "#{train.number}, #{train.type}, #{train.wagons.count}"
        train.yield_wagons do |wagon|
          wagon_data = if wagon.type == 'passenger'
                         "seats: busy - #{wagon.used_place}, vacant - #{wagon.free_place}"
                       elsif wagon.type == 'cargo'
                         "volume: used - #{wagon.used_place}, free - #{wagon.free_place}"
                       end
          puts "\t #{wagon.number}, #{wagon_data}"
        end
      end
    end
    puts '========================================================'
  end

  #############################################################################

  def show_main_menu
    puts 'Available options:
     ================================
     1. Manage stations
     2. Manage trains
     3. Manage routes
     4. List program data(routes, stations, trains)
     ================================
     0. Exit the menu
     ================================'
    puts 'Enter the command number:'
  end

  #############################################################################
end

program = Main.new
st1 = Station.new('first')
st2 = Station.new('last')
r = Route.new(st1, st2)
ctr = CargoTrain.new('ctr-99')
cw1 = CargoWagon.new(100)
cw2 = CargoWagon.new(100)
cw1.use_place(10)
cw2.use_place(20)
ctr.add_wagon(cw1)
ctr.add_wagon(cw2)
ctr.route = r
ptr = PassengerTrain.new('ptr-77')
pw1 = PassengerWagon.new(50)
pw2 = PassengerWagon.new(50)
pw1.use_place(15)
pw2.use_place(25)
ptr.add_wagon(pw1)
ptr.add_wagon(pw2)
ptr.route = r

program.routes << r
program.stations << st1
program.stations << st2
program.trains << ctr
program.trains << ptr

program.options
