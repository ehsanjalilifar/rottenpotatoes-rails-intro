module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def isChecked(rating)
    if params[:ratings].nil? 
      return true 
    else
      return (params[:ratings].include? rating)
    end
  end
   
end
