module MoviesHelper
  def highlighter(column)
    if @sorted_by == column
      "hilite"
    end
  end
end
