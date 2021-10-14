
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  if uncheck == "un"
    rating_list.split(',').each do |num|
      step %{I uncheck "ratings_#{num}"}
    end
  else
    rating_list.split(',').each do |num|
      step %{I check "ratings_#{num}"}
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    step %{I should see "#{movie.title}"}
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |movie_name, director_name|
  # Make sure that the director of movie is correct
  Movie.exists?(title: movie_name, director: director_name).should be_truthy
end