# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create( {
                name: 'rogerio',
                email: 'rbispo@rbispo.com.br',
                time_zone: 'America/Sao_Paulo',
                password: '123456',
                password_confirmation: '123456'
            })


            genre = Genre.create(name: 'Rock')

            genre2 = Genre.create(name: 'Pop/Rock')

            Artist.create({
                            name: 'The Beatles',
                            member_quantity: 4,
                            genre: genre2,
                            note: 'they wanna drink wine'
                          })
        
            Artist.create({
                                      name: 'AC/DC',
                                      member_quantity: 5,
                                      genre: genre,
                                      note: 'they wanna caipirinha'
                                    })
        