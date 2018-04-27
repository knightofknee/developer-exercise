import React, { Component } from 'react';
import axios from 'axios'
import './quotes.css'

export default class Quotes extends Component {

  constructor(){
    super()
    this.state = {
      dataArray: [{},{quote: ''}],
      dataCount: 0,
      pageNumber: 1,
      theme: '',
      search: '',
      text: ''
    }
    this.nextPage = this.nextPage.bind(this)
    this.previousPage = this.previousPage.bind(this)
    this.setThemeFilter = this.setThemeFilter.bind(this)
    this.textChange = this.textChange.bind(this)
    this.searchSubmit = this.searchSubmit.bind(this)
    this.clearSearch = this.clearSearch.bind(this)
    this.countPerPage = 15;
  }

  componentWillMount(){
    axios.get("https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json")
    .then(res => {
      this.setState({dataArray: res.data})
    })
    .catch(console.error)
  }
  nextPage(){
    // let countPerPage = 15;
    this.setState(function (prevState, props){
      return {dataCount: prevState.dataCount + this.countPerPage,
      pageNumber : prevState.pageNumber + 1}
    })
  }
  previousPage(){
    this.setState(function (prevState, props){
      return {dataCount: prevState.dataCount - this.countPerPage,
        pageNumber : prevState.pageNumber - 1}
    })
  }
  setThemeFilter(theme){
    return () => {
    this.setState({theme, dataCount: 0, pageNumber: 1})}
  }
  textChange(event){
    this.setState({text: event.target.value})
  }
  searchSubmit(event){
    this.setState({search: this.state.text, dataCount: 0, pageNumber: 1})
    event.preventDefault()
  }
  clearSearch(){
    this.setState({search: '', text: '', dataCount: 0, pageNumber: 1})
  }

  render () {
    let displayCount = this.state.dataArray.filter((entry)=>{
      return (entry.theme == this.state.theme) || this.state.theme == ''}).filter((entry) => {
        if (entry.quote) return entry.quote.includes(this.state.search)
        else return false}).slice(this.state.dataCount, this.state.dataCount + this.countPerPage + 1).length
        console.log('hiya', displayCount)
    return (
      <div>
        <h1>Quote List</h1>
        <div className="nav-row">
          <form className="nav-item" onSubmit={this.searchSubmit}>
            <input id="text-box" type="text" value={this.state.text} onChange={this.textChange} placeholder="Enter text for search here"/>
            <input type="submit" value="Search"/>
          </form>
          <button disabled={!this.state.search} className="nav-item" onClick={this.clearSearch} type="button" style={{backgroundColor: this.state.search ? '#FF99FF' : 'white'}}>Clear Search</button>
          <button className="nav-item" onClick={this.setThemeFilter('')} type="button"> All</button>
          <button className="nav-item" onClick={this.setThemeFilter('movies')} type="button" style={{backgroundColor: this.state.theme == 'movies' ? '#FF99FF' : 'white'}}> Movies</button>
          <button className="nav-item" onClick={this.setThemeFilter('games')} type="button" style={{backgroundColor: this.state.theme == 'games' ? '#FF99FF' : 'white'}}> Games</button>
          <span className="nav-item">Page: {' ' + this.state.pageNumber}</span>
          <button className="nav-item" type="button" disabled={(this.state.dataCount) < this.countPerPage} onClick={this.previousPage}> Previous Page</button>
          <button className="nav-item" type="button" disabled={displayCount <= this.countPerPage} onClick={this.nextPage}> Next Page</button>
        </div>
        <div className="q-row">
          <div className="q-column1">Source</div>
          <div className="q-column2">Context</div>
          <div className="q-column3">Theme</div>
          <div className="q-column4">Quote</div>
        </div>
        {this.state.dataArray.filter((entry)=>{
          return (entry.theme == this.state.theme) || this.state.theme == ''}).filter((entry) => {
            if (entry.quote) return entry.quote.includes(this.state.search)
            else return false
          }).slice(this.state.dataCount, this.state.dataCount + this.countPerPage).map(function(entry) {
          return (
          <div className="q-row">
            <div className="q-column1">{entry.source}</div>
            <div className="q-column2"> {entry.context} </div>
            <div className="q-column3"> {entry.theme} </div>
            <div className="q-column4"> {entry.quote} </div>
          </div>)
        })}
        <div className="nav-row">
          <span className="nav-item">Page: {' ' + this.state.pageNumber}</span>
          <button className="nav-item" type="button" disabled={(this.state.dataCount) < this.countPerPage} onClick={this.previousPage}> Previous Page</button>
          <button className="nav-item" type="button" disabled={(this.state.dataArray.length - this.state.dataCount) < this.countPerPage} onClick={this.nextPage}> Next Page</button>
        </div>

      </div>
    );
  }
}

// issues list:
// display count might not be good performance, am doing a lot just for disabling the next page button. currently forced into it since our filtering is in our render section
