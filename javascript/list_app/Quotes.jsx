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
      theme: ''
    }
    this.nextPage = this.nextPage.bind(this)
    this.previousPage = this.previousPage.bind(this)
    this.setThemeFilter = this.setThemeFilter.bind(this)
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

  render () {
    // let visibleQuotes = []
    // let endCount = Math.min(this.state.dataCount + this.countPerPage, this.state.dataArray.length)
    // for (let i = this.state.dataCount; i < endCount; i++) {
    //   if (this.state.filter) {

    //   }
    //   visibleQuotes[i] = this.state.dataArray[i]
    // }
    // let i = this.state.dataCount
    // while ((visibleQuotes.length < this.countPerPage + this.state.dataCount) && (i < this.state.dataArray.length)){
    //   if (this.state.filter){
    //     if (this.state.dataArray[i].theme == this.state.filter) visibleQuotes[i] = this.state.dataArray[i]
    //   }
    //   else visibleQuotes[i] = this.state.dataArray[i]
    //   i++
    //   console.log('hi, i: ', visibleQuotes.length,  this.countPerPage )
    // }
    // visibleQuotes = visibleQuotes.filter(function(entry){
    //   return entry.theme == 'games'
    // })
    // console.log('result array: ', this.state.dataArray.filter((entry)=>{
    //   return entry.theme == this.state.filter}).slice(this.state.dataCount, this.state.dataCount + this.countPerPage))
    //   console.log('part: ', this.state.dataCount, this.state.dataCount + 15)

    return (
      <div>
        <h1>Quote List</h1>
        <div className="nav-row">
          <button className="nav-item" onClick={this.setThemeFilter('')} type="button"> All</button>
          <button className="nav-item" onClick={this.setThemeFilter('movies')} type="button"> Movies</button>
          <button className="nav-item" onClick={this.setThemeFilter('games')} type="button"> Games</button>
          <span className="nav-item">Page: {' ' + this.state.pageNumber}</span>
          <button className="nav-item" type="button" disabled={(this.state.dataCount) < this.countPerPage} onClick={this.previousPage}> Previous Page</button>
          <button className="nav-item" type="button" disabled={(this.state.dataArray.length - this.state.dataCount) < this.countPerPage} onClick={this.nextPage}> Next Page</button>
        </div>
        <div className="q-row">
          <div className="q-column1">Source</div>
          <div className="q-column2">Context</div>
          <div className="q-column3">Theme</div>
          <div className="q-column4">Quote</div>
        </div>
        {this.state.dataArray.filter((entry)=>{
          return (entry.theme == this.state.theme) || this.state.theme == ''}).slice(this.state.dataCount, this.state.dataCount + this.countPerPage).map(function(entry) {
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
