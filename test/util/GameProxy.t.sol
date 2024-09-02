// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {GamePlayed} from "game/Game.sol";

import {GameProxy, IGameProxy} from "game/GameProxy.sol";
import {Hand, RPS} from "game/RPS.sol";

contract RPSProxyTest is Test {
    RPS rps;
    GameProxy gameProxy;
    Hand[] hands;

    function setUp() public {
        rps = new RPS();
        gameProxy = new GameProxy();
        gameProxy.setGame(IGameProxy.GameMeta(0, address(rps), 0, 100, 1000));
        hands.push(Hand.Rock);
        hands.push(Hand.Paper);
        hands.push(Hand.Scissors);
    }

    function test_play() public {
        vm.expectEmit(true, true, true, false, address(rps));
        emit GamePlayed(address(this), block.number, "RPS");
        rps.play(100, abi.encode(hands));
    }

    function test_play_callViaProxy() public {
        vm.expectEmit(true, true, true, false, address(gameProxy));
        emit GamePlayed(address(this), block.number, "RPS");
        (bool res,) =
            address(gameProxy).call(abi.encodeWithSelector(GameProxy.play.selector, 0, 100, abi.encode(hands)));
        assertTrue(res);
    }

    function testFail_setGame_notOwner() public {
        vm.prank(vm.randomAddress());
        gameProxy.setGame(IGameProxy.GameMeta(1, address(rps), 0, 100, 1000));
    }
}
