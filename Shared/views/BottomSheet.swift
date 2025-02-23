//
//  BottomSheet.swift
//  weather_info (iOS)
//
//  Created by vignesh on 23/02/25.
//

import SwiftUI


import SwiftUI

/// 🌟 Reusable Bottom Sheet for iOS 15
struct ReusableBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isPresented ? 0 : maxHeight
    }

    private var indicator: some View {
        Capsule()
            .frame(width: 40, height: 5)
            .foregroundColor(Color.gray.opacity(0.5))
            .padding(8)
    }

    init(
        isPresented: Binding<Bool>,
        maxHeight: CGFloat = UIScreen.main.bounds.height * 0.6,
        minHeight: CGFloat = 100,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.maxHeight = maxHeight
        self.minHeight = minHeight
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            if isPresented {
                ZStack(alignment: .bottom) {
                    // Dimmed background
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isPresented = false
                            }
                        }

                    // Bottom Sheet
                    VStack(spacing: 0) {
                        indicator
                        content
                    }
                    .frame(width: geometry.size.width, height: maxHeight, alignment: .top)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    )
                    .offset(y: offset + translation)
                    .animation(.interactiveSpring(), value: isPresented)
                    .gesture(
                        DragGesture().updating($translation) { value, state, _ in
                            state = value.translation.height
                        }
                        .onEnded { value in
                            if value.translation.height > 100 {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                        }
                    )
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

struct BottomSheetExample: View {
    @State private var showBottomSheet = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Reusable Bottom Sheet - iOS 15 Compatible 🎯")
                    .font(.title2)
                    .bold()

                Button(action: {
                    withAnimation {
                        showBottomSheet.toggle()
                    }
                }) {
                    Text("Show Bottom Sheet")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea()

        // 💡 Integrating the Reusable Bottom Sheet
        ReusableBottomSheet(isPresented: $showBottomSheet) {
            VStack(spacing: 16) {
                Text("🎉 Custom Bottom Sheet")
                    .font(.title3)
                    .bold()

                Text("This bottom sheet works seamlessly on iOS 15 with custom heights and gestures.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button(action: {
                    withAnimation {
                        showBottomSheet = false
                    }
                }) {
                    Text("Dismiss")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct BottomSheetExample_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetExample()
    }
}





