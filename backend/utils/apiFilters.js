class APIFilters {
  constructor(query, queryStr) {
    this.query = query;
    this.queryStr = queryStr;
  }

  search() {
    const keyword = this.queryStr.keyword
      ? {
          name: {
            $regex: this.queryStr.keyword,
            $options: "i",
          },
        }
      : {};

    this.query = this.query.find({ ...keyword });
    return this;
  }
  findProductByCategory() {

    const category = this.queryStr.category;

    if (category) {
      this.query = this.query.find({ category }); // Apply the category filter
    }

    return this;
  }

  sort( ) {
    const price = this.queryStr.price;
    const name = this.queryStr.name;
    if( price){
      this.query =  this.query.find({}).sort({price:price})
    }
    if(name){
      this.query = this.query.find({}).sort({name:name})
    }
    return this
  }
  
  filters() {
    const queryCopy = { ...this.queryStr };

    // Fields to remove
    const fieldsToRemove = ["keyword", "page","category","price","name"];
    fieldsToRemove.forEach((el) => delete queryCopy[el]);

    // Advance filter for price, ratings etc
    let queryStr = JSON.stringify(queryCopy);
    queryStr = queryStr.replace(/\b(gt|gte|lt|lte)\b/g, (match) => `$${match}`);

    this.query = this.query.find(JSON.parse(queryStr));
    return this;
  }

  pagination(resPerPage) {
    const currentPage = Number(this.queryStr.page) || 1;
    const skip = resPerPage * (currentPage - 1);

    this.query = this.query.limit(resPerPage).skip(skip);
    return this;
  }
}

export default APIFilters;
