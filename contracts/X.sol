// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract X {

    uint16 public MAX_TWEET_LENGTH = 280;

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    mapping(address => Tweet[] ) public tweets;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "YOU ARE NOT THE OWNER!");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "TWEET TOO LONG!");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
    }

    function likeTweet(address _author, uint256 _id) external{
        require(tweets[_author][_id].id == _id, "TWEET DOES NOT EXIST!");

        tweets[_author][_id].likes++;
    }

    function unlikeTweet(address _author, uint256 _id) external{
        require(tweets[_author][_id].id == _id, "TWEET DOES NOT EXIST!");
        require(tweets[_author][_id].likes > 0, "TWEET HAS NO LIKES!");
        
        tweets[_author][_id].likes--;
    }

    function getTweet(address _owner, uint _i) public view returns (Tweet memory) {
        return tweets[_owner][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory ){
        return tweets[_owner];
    }

}