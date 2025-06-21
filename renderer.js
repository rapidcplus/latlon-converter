document.addEventListener('DOMContentLoaded', function() {
    const convertButton = document.getElementById('convertButton');
    const latitudeInput = document.getElementById('latitudeInput');
    const longitudeInput = document.getElementById('longitudeInput');
    const resultLatitude = document.getElementById('resultLatitude');
    const resultLongitude = document.getElementById('resultLongitude');

    // 10進法を60進法に変換する関数
    function decimalToDMS(decimal, isLatitude = true) {
        const absolute = Math.abs(decimal);
        const degrees = Math.floor(absolute);
        const minutesFloat = (absolute - degrees) * 60;
        const minutes = Math.floor(minutesFloat);
        const seconds = (minutesFloat - minutes) * 60;
        
        // 方位の判定
        let direction;
        if (isLatitude) {
            direction = decimal >= 0 ? 'N' : 'S';
        } else {
            direction = decimal >= 0 ? 'E' : 'W';
        }
        
        return {
            degrees: degrees,
            minutes: minutes,
            seconds: parseFloat(seconds.toFixed(3)),
            direction: direction,
            formatted: `${degrees}° ${minutes}' ${seconds.toFixed(3)}" ${direction}`
        };
    }

    // 変換ボタンのクリックイベント
    convertButton.addEventListener('click', function() {
        const latValue = parseFloat(latitudeInput.value);
        const lonValue = parseFloat(longitudeInput.value);
        
        // 入力値の検証
        if (isNaN(latValue) || isNaN(lonValue)) {
            alert('有効な数値を入力してください');
            return;
        }
        
        // 緯度の範囲チェック (-90 ≤ lat ≤ 90)
        if (latValue < -90 || latValue > 90) {
            alert('緯度は-90から90の範囲で入力してください');
            return;
        }
        
        // 経度の範囲チェック (-180 ≤ lon ≤ 180)
        if (lonValue < -180 || lonValue > 180) {
            alert('経度は-180から180の範囲で入力してください');
            return;
        }
        
        // 変換実行
        const latDMS = decimalToDMS(latValue, true);
        const lonDMS = decimalToDMS(lonValue, false);
        
        // 結果表示
        resultLatitude.textContent = latDMS.formatted;
        resultLongitude.textContent = lonDMS.formatted;
    });

    // Enterキーでも変換できるようにする
    [latitudeInput, longitudeInput].forEach(input => {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                convertButton.click();
            }
        });
    });
});
