import Swinject

extension AppDelegate {
    class func createContainer() -> Container {
        let container = Container()
        
        container.register(SearchResultsViewController.self) { resolver in
            let viewModel = resolver.resolve(SearchResultsViewModel.self)!
            return SearchResultsViewController(viewModel: viewModel)
        }
        
        container.register(SearchResultsViewModel.self) { resolver in
            return SearchResultsViewModel()
        }
        
        return container
    }
}
