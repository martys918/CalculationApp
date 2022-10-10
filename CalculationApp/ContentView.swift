//
//  ContentView.swift
//  CalculationApp
//

import SwiftUI

enum CalculateState {
    case initial
    case add
    case sub
    case div
    case mul
    case sum
}

struct ContentView: View {

    @State var selectedItem: String = "0"
    @State var calculatedNumber: Double = 0
    @State var calculateState: CalculateState = .initial

    private let calculateItems: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="],
    ]

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack {

                HStack {
                    Spacer()
//                    Text("hello, calc")
//                        .foregroundColor(.white)

                    Text(selectedItem == "0" ? checkDecimal(number: calculatedNumber) : selectedItem)
                        .font(.system(size: 100, weight: .light))
                        .foregroundColor(Color.white)
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                ForEach(calculateItems, id: \.self) { items in
                    NumberView(
                        selectedItem: $selectedItem,
                        calculatedNumber: $calculatedNumber,
                        calculateState: $calculateState,
                        items: items
                    )
                }
            }
                .padding()
        }
    }
    private func checkDecimal(number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne) {
            return String(Int(number))
        }
        else {
            return String(number)
        }
    }
}

struct NumberView: View {
    @Binding var selectedItem: String
    @Binding var calculatedNumber: Double
    @Binding var calculateState: CalculateState

    var items: [String]

    private let numbers: [String] = [
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."
    ]

    private let symbols: [String] = [
        "÷", "×", "-", "+", "="
    ]

    private let buttonWidth: CGFloat = (UIScreen.main.bounds.width - 50) / 4
    private let buttonHeight: CGFloat = (UIScreen.main.bounds.width - 50) / 4

    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                Button {
                    bundleButtonInfo(item: item)
                } label: {
                    Text(item)
                        .font(.system(size: 20, weight: .light))
                        .frame(
                            minWidth: 0, maxWidth: .infinity,
                            minHeight: 0, maxHeight: .infinity
                        )
                }
                    .foregroundColor(numbers.contains(item) || symbols.contains(item) ? .white : .black)
                    .background(bundleButtonColor(item: item))
                    .frame(width: item == "0" ? buttonWidth * 2 + 10 : buttonWidth)
                    .cornerRadius(buttonWidth)
            }
                .frame(height: buttonHeight)
        }
    }

    private func bundleButtonInfo(item: String) {
        guard selectedItem.count < 10 else {
            return
        }

        if numbers.contains(item) {
            if item == "." && (selectedItem.contains(".") || selectedItem.contains("0")) {
                return
            }
            if calculateState == .sum {
                calculatedNumber = 0
            }

            if selectedItem == "0" {
                selectedItem = item
                return
            }

            selectedItem += item
        } else if item == "AC" {
            selectedItem = "0"
            calculatedNumber = 0
            calculateState = .initial
        }

        guard let selectedNumber = Double(selectedItem) else {
            return
        }

        // 計算記号
        if item == "+" {
            setCalculate(state: .add, selectedNumber: selectedNumber)
        }
        else if item == "-" {
            setCalculate(state: .sub, selectedNumber: selectedNumber)
        }
        else if item == "×" {
            setCalculate(state: .mul, selectedNumber: selectedNumber)
        }
        else if item == "÷" {
            setCalculate(state: .div, selectedNumber: selectedNumber)
        }
        else if item == "=" {
            selectedItem = "0"
            calculate(selectedNumber: selectedNumber)
            calculateState = .sum
        }
    }

    private func setCalculate(state: CalculateState, selectedNumber: Double) {
        if selectedItem == "0" {
            calculatedNumber = selectedNumber
            return
        }

        selectedItem = "0"
        calculateState = state
        calculate(selectedNumber: selectedNumber)
    }

    private func calculate(selectedNumber: Double) {
        if calculatedNumber == 0 {
            calculatedNumber = selectedNumber
            return
        }
        switch calculateState {
        case .add:
            calculatedNumber = calculatedNumber + selectedNumber
        case .sub:
            calculatedNumber = calculatedNumber - selectedNumber
        case .div:
            calculatedNumber = calculatedNumber / selectedNumber
        case .mul:
            calculatedNumber = calculatedNumber * selectedNumber
        default:
            break
        }
    }

    private func bundleButtonColor(item: String) -> Color {
        if numbers.contains(item) {
            return Color(white: 0.2, opacity: 1)
        } else if symbols.contains(item) {
            return Color.orange
        }
        return Color(white: 0.8, opacity: 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
