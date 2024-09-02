// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.26;

// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import {Cookie, CookieVendor} from "station/Cookie.sol";

// import {IGame} from "game/Game.sol";
// import {GameManager, IGameManager} from "game/GameManager.sol";
// import {IOracle, Oracle} from "station/Oracle.sol";

// import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

// // interface IStation {
// //     function depositLP(uint256 _amount) external;

// //     function withdrawLP(uint256 _amount) external;

// //     function playMulti(bytes[] calldata _data) external;
// // }

// /// @dev 반드시 admin 계정을 통해서만 오라클을 설정하고 실행해야 함
// contract Station is UUPSUpgradeable, CookieVendor, Ownable {
//     // stoppable
//     IOracle public oracle;
//     GameManager internal gm;

//     error InvalidAmount();

//     // only for initial setup
//     constructor(address _game) Ownable(msg.sender) {
//         oracle = new Oracle();
//         gm = GameManager(_game);
//         require(cookie.balanceOf(address(this)) == type(uint256).max);
//     }

//     /* --- External Functions --- */

//     function getGameMeta(uint256 _id) public view returns (IGameManager.GameMeta memory) {
//         return gm.getGameMeta(_id);
//     }

//     function setGame(IGameManager.GameMeta calldata _meta) public onlyOwner {
//         gm.setGame(_meta);
//     }

//     function setGame(uint256 _id, address _logic, uint256 _version, uint256 _minAmount, uint256 _maxAmount)
//         external
//         onlyOwner
//     {
//         gm.setGame(createGameMeta(_id, _logic, _version, _minAmount, _maxAmount));
//     }

//     function claim() external {
//         uint256 reward = gm.claim();
//         require(reward > 0 && cookie.transfer(msg.sender, reward), "Station: ClaimFailed");
//     }

//     function playMulti(bytes[] calldata _data) external {
//         for (uint256 i = 0; i < _data.length; ++i) {
//             (uint256 gameId, uint256 amount, bytes memory data) = abi.decode(_data[i], (uint256, uint256, bytes));
//             play(gameId, amount, data);
//         }
//     }

//     function playRandom(uint256 _gameId, uint256 _amount, uint256 _length) external {
//         playRandom(_gameId, _amount, _length, 0);
//     }

//     /* --- Public Functions --- */

//     function playRandom(uint256 _gameId, uint256 _amount, uint256 _length, bytes32 _seed) public {
//         IGameManager.GameMeta memory meta = gm.getGameMeta(_gameId);
//         authorizePlay(meta, _amount);
//         bytes memory data = abi.encodeWithSelector(IGame.playRandom.selector, _amount, _length);
//         if (_seed != 0) {
//             data = bytes.concat(data, abi.encode(_seed));
//         }
//         (bool res,) = meta.logic.delegatecall(data);
//         require(res);
//     }

//     function play(uint256 _gameId, uint256 _amount, bytes memory _data) public {
//         IGameManager.GameMeta memory meta = gm.getGameMeta(_gameId);
//         authorizePlay(meta, _amount);
//         (bool res,) = meta.logic.delegatecall(abi.encodeWithSelector(IGame.play.selector, _amount, _data));
//         require(res);
//     }

//     /* --- Internal Functions --- */

//     function createGameMeta(uint256 _id, address _logic, uint256 _version, uint256 _minAmount, uint256 _maxAmount)
//         internal
//         pure
//         returns (IGameManager.GameMeta memory)
//     {
//         return IGameManager.GameMeta(_id, _logic, _version, _minAmount, _maxAmount);
//     }

//     function authorizePlay(IGameManager.GameMeta memory meta, uint256 _amount) internal {
//         require(meta.minAmount <= _amount && _amount <= meta.maxAmount, InvalidAmount());
//         require(cookie.transferFrom(msg.sender, address(this), _amount), TransferFailed());
//     }

//     function _authorizeUpgrade(address newImplementation) internal view override onlyOwner {}
// }
