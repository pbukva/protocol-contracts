// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./AbstractRoyalties.sol";
import "../RoyaltiesV1.sol";

contract RoyaltiesV1Impl is AbstractRoyalties, RoyaltiesV1 {

    function getFeeRecipients(uint256 id) public override view returns (address payable[] memory) {
        LibPart.Part[] memory _royalties = royalties[id];
        address payable[] memory result = new address payable[](_royalties.length);
        for (uint i = 0; i < _royalties.length; ++i) {
            result[i] = _royalties[i].account;
        }
        return result;
    }

    function getFeeBps(uint256 id) public override view returns (uint[] memory) {
        LibPart.Part[] memory _royalties = royalties[id];
        uint[] memory result = new uint[](_royalties.length);
        for (uint i = 0; i < _royalties.length; ++i) {
            result[i] = _royalties[i].value;
        }
        return result;
    }

    function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) override internal {
        address[] memory recipients = new address[](_royalties.length);
        uint[] memory bps = new uint[](_royalties.length);
        for (uint i = 0; i < _royalties.length; ++i) {
            LibPart.Part[] memory _royalty = _royalties[i];
            recipients[i] = _royalty.account;
            bps[i] = _royalty.value;
        }
        emit SecondarySaleFees(id, recipients, bps);
    }
}
