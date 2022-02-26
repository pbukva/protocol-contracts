// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../LibPart.sol";

abstract contract AbstractRoyalties {
    uint96 constant denominator = 10000;
    mapping (uint256 => LibPart.Part[]) internal royalties;

    function _saveRoyalties(uint256 id, LibPart.Part[] memory _royalties) internal {
        uint256 totalValue;
        LibPart.Part[] storage stor_royalties = royalties[id];

        for (uint i = 0; i < stor_royalties.length; ++i) {
            totalValue += stor_royalties[i].value;
        }

        for (uint i = 0; i < _royalties.length; ++i) {
            LibPart.Part memory _royalty = _royalties[i];
            require(_royalty.account != address(0x0), "Recipient must be present");
            require(_royalty.value != 0, "Royalty value must be positive");
            require(_royalty.value < denominator, "Royalty value should be ");
            totalValue += _royalty.value;
            stor_royalties.push(_royalty);
        }

        require(totalValue < 10000, "Royalty total value should be < 10000");

        _onRoyaltiesSet(id, _royalties);
    }

    function _updateAccount(uint256 _id, address _from, address _to) internal {
        LibPart.Part[] storage _royalties = royalties[_id];
        uint length = _royalties.length;
        for(uint i = 0; i < length; ++i) {
            LibPart.Part storage royalty = _royalties[i];
            if (royalty.account == _from) {
                royalty.account = payable(_to);
            }
        }
    }

    function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) virtual internal;
}
